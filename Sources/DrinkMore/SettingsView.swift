import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine
    @EnvironmentObject private var language: LanguageSettings
    @State private var settings = ReminderSettings()

    var body: some View {
        Form {
            Picker(L10n.text(.language, language.language), selection: $language.language) {
                ForEach(AppLanguage.allCases) { appLanguage in
                    Text(appLanguage.title).tag(appLanguage)
                }
            }
            Toggle(L10n.text(.enableReminders, language.language), isOn: $settings.isEnabled)
            Stepper(L10n.intervalMinutes(settings.intervalMinutes, language.language), value: $settings.intervalMinutes, in: 5...240, step: 5)
            Stepper(L10n.fullScreenGrace(settings.fullScreenGraceSeconds, language.language), value: $settings.fullScreenGraceSeconds, in: 15...600, step: 15)

            HStack {
                Button(L10n.text(.saveReminderSettings, language.language)) {
                    store.updateReminder(settings)
                    reminder.reschedule()
                }
                .keyboardShortcut(.defaultAction)

                Button(L10n.text(.testFullScreenReminder, language.language)) {
                    reminder.snooze(minutes: 0)
                }
            }

            if let next = reminder.nextReminderAt {
                Text(L10n.nextReminderFull(next, language.language))
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
