import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine
    @EnvironmentObject private var language: LanguageSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(L10n.todayTotal(store.todayTotalML, language.language))
                    .font(.headline)
                Spacer()
                Button {
                    NSApp.activate(ignoringOtherApps: true)
                    NSApp.windows.first?.makeKeyAndOrderFront(nil)
                } label: {
                    Image(systemName: "arrow.up.forward.app")
                }
                .buttonStyle(.borderless)
            }

            ForEach(store.data.cups.prefix(5)) { cup in
                Button {
                    store.addDrink(cup: cup)
                    reminder.acknowledge()
                } label: {
                    Label("\(cup.name) · \(cup.volumeML) ml", systemImage: icon(for: cup.kind))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Divider()

            if let next = reminder.nextReminderAt {
                Text(L10n.nextReminder(next, language.language))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Button(L10n.text(.snooze10, language.language)) { reminder.snooze() }
                Button(L10n.text(.quit, language.language)) { NSApp.terminate(nil) }
            }
        }
        .padding(14)
        .frame(width: 280)
    }
}
