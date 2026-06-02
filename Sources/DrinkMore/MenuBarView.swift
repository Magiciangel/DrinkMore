import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("今天 \(store.todayTotalML) ml")
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
                Text("下次提醒 \(next.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Button("稍后 10 分钟") { reminder.snooze() }
                Button("退出") { NSApp.terminate(nil) }
            }
        }
        .padding(14)
        .frame(width: 280)
    }
}
