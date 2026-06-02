import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine
    @State private var settings = ReminderSettings()

    var body: some View {
        Form {
            Toggle("开启提醒", isOn: $settings.isEnabled)
            Stepper("倒计时 \(settings.intervalMinutes) 分钟", value: $settings.intervalMinutes, in: 5...240, step: 5)
            Stepper("通知后 \(settings.fullScreenGraceSeconds) 秒全屏提醒", value: $settings.fullScreenGraceSeconds, in: 15...600, step: 15)

            HStack {
                Button("保存提醒设置") {
                    store.updateReminder(settings)
                    reminder.reschedule()
                }
                .keyboardShortcut(.defaultAction)

                Button("立刻测试全屏提醒") {
                    reminder.snooze(minutes: 0)
                }
            }

            if let next = reminder.nextReminderAt {
                Text("下次提醒：\(next.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .onAppear {
            settings = store.data.reminder
        }
        .onChange(of: store.data.reminder) { _, newValue in
            settings = newValue
        }
    }
}
