import AppKit
import SwiftUI
import UserNotifications

@main
struct DrinkMoreApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var store = AppStore()
    @StateObject private var reminder = ReminderEngine()
    @StateObject private var language = LanguageSettings()

    var body: some Scene {
        WindowGroup("DrinkMore", id: AppWindow.main) {
            ContentView()
                .environmentObject(store)
                .environmentObject(reminder)
                .environmentObject(language)
                .task {
                    reminder.configure(store: store)
                    await reminder.requestNotificationAccess()
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }

        MenuBarExtra("DrinkMore", systemImage: "drop.fill") {
            MenuBarView()
                .environmentObject(store)
                .environmentObject(reminder)
                .environmentObject(language)
        }
        .menuBarExtraStyle(.window)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        UNUserNotificationCenter.current().delegate = self
        configureNotificationActions()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        switch response.actionIdentifier {
        case NotificationAction.acknowledge:
            NotificationCenter.default.post(name: .drinkReminderAcknowledged, object: nil)
        case NotificationAction.snooze:
            NotificationCenter.default.post(name: .drinkReminderSnoozed, object: nil)
        case UNNotificationDefaultActionIdentifier:
            await MainActor.run {
                NSApp.activate(ignoringOtherApps: true)
            }
        default:
            break
        }
    }

    private func configureNotificationActions() {
        let acknowledge = UNNotificationAction(
            identifier: NotificationAction.acknowledge,
            title: L10n.text(.acknowledged),
            options: []
        )
        let snooze = UNNotificationAction(
            identifier: NotificationAction.snooze,
            title: L10n.text(.snooze10),
            options: []
        )
        let category = UNNotificationCategory(
            identifier: NotificationAction.category,
            actions: [acknowledge, snooze],
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

enum NotificationAction {
    static let category = "DRINK_REMINDER"
    static let acknowledge = "DRINK_REMINDER_ACKNOWLEDGE"
    static let snooze = "DRINK_REMINDER_SNOOZE"
}

enum AppWindow {
    static let main = "main"
}

extension Notification.Name {
    static let drinkReminderAcknowledged = Notification.Name("drinkReminderAcknowledged")
    static let drinkReminderSnoozed = Notification.Name("drinkReminderSnoozed")
}
