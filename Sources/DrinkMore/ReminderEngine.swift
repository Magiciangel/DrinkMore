import AppKit
import SwiftUI
import UserNotifications

@MainActor
final class ReminderEngine: ObservableObject {
    @Published private(set) var nextReminderAt: Date?
    @Published var isReminderVisible = false

    private weak var store: AppStore?
    private var reminderTimer: Timer?
    private var fullScreenTimer: Timer?
    private var window: NSWindow?
    private var observers: [NSObjectProtocol] = []

    func configure(store: AppStore) {
        self.store = store
        configureObserversIfNeeded()
        reschedule()
    }

    func requestNotificationAccess() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }

    func reschedule() {
        reminderTimer?.invalidate()
        fullScreenTimer?.invalidate()

        guard let settings = store?.data.reminder, settings.isEnabled else {
            nextReminderAt = nil
            return
        }

        let fireDate = Date().addingTimeInterval(TimeInterval(settings.intervalMinutes * 60))
        nextReminderAt = fireDate
        reminderTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(reminderFired), userInfo: nil, repeats: false)
        RunLoop.main.add(reminderTimer!, forMode: .common)
    }

    func acknowledge() {
        clearDeliveredNotifications()
        hideFullScreenReminder()
        reschedule()
    }

    func snooze(minutes: Int = 10) {
        clearDeliveredNotifications()
        hideFullScreenReminder()
        reminderTimer?.invalidate()
        let fireDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        nextReminderAt = fireDate
        reminderTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(reminderFired), userInfo: nil, repeats: false)
        RunLoop.main.add(reminderTimer!, forMode: .common)
    }

    @objc private func reminderFired() {
        Task { await sendNotification() }

        let grace = store?.data.reminder.fullScreenGraceSeconds ?? 90
        fullScreenTimer?.invalidate()
        fullScreenTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(grace), repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.showFullScreenReminder()
            }
        }
    }

    private func sendNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "该喝水了"
        content.body = "起来喝一杯，顺手记录一下。"
        content.sound = .default
        content.categoryIdentifier = NotificationAction.category

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        try? await UNUserNotificationCenter.current().add(request)
    }

    private func configureObserversIfNeeded() {
        guard observers.isEmpty else { return }

        let notificationCenter = NotificationCenter.default
        observers.append(
            notificationCenter.addObserver(forName: .drinkReminderAcknowledged, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.acknowledge() }
            }
        )
        observers.append(
            notificationCenter.addObserver(forName: .drinkReminderSnoozed, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.snooze() }
            }
        )

        let workspaceCenter = NSWorkspace.shared.notificationCenter
        observers.append(
            workspaceCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.pauseForSleep() }
            }
        )
        observers.append(
            workspaceCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor in self?.reschedule() }
            }
        )
    }

    private func pauseForSleep() {
        reminderTimer?.invalidate()
        fullScreenTimer?.invalidate()
        hideFullScreenReminder()
    }

    private func clearDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func showFullScreenReminder() {
        guard !isReminderVisible else { return }
        isReminderVisible = true

        let view = FullScreenReminderView(
            onDrink: { [weak self] in self?.acknowledge() },
            onSnooze: { [weak self] in self?.snooze() }
        )

        let hosting = NSHostingView(rootView: view)
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1200, height: 800)
        let window = NSWindow(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        window.contentView = hosting
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        self.window = window
    }

    private func hideFullScreenReminder() {
        fullScreenTimer?.invalidate()
        window?.orderOut(nil)
        window = nil
        isReminderVisible = false
    }
}
