import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(store.todayTotalML) ml")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                Text("今天总摄入")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Spacer()
                if let next = reminder.nextReminderAt {
                    Text("下次提醒 \(next.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(.secondary)
                }
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 12)], spacing: 12) {
                ForEach(store.data.cups) { cup in
                    Button {
                        store.addDrink(cup: cup)
                        reminder.acknowledge()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(cup.name, systemImage: icon(for: cup.kind))
                                .font(.headline)
                            Text("\(cup.volumeML) ml · 今天 \(store.todayCupCount(for: cup)) 杯")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(drinkTint(for: cup.kind))
                }
            }

            Text("今日记录")
                .font(.headline)

            List {
                ForEach(store.todayEntries.reversed()) { entry in
                    HStack {
                        Label(entry.cupName, systemImage: icon(for: entry.kind))
                        Spacer()
                        Text("\(entry.volumeML) ml")
                        Text(entry.date.formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                    .contextMenu {
                        Button("删除") {
                            store.removeEntry(entry)
                        }
                    }
                }
            }
        }
    }
}

func icon(for kind: DrinkKind) -> String {
    switch kind {
    case .water: "drop.fill"
    case .coffee: "cup.and.saucer.fill"
    case .tea: "leaf.fill"
    case .other: "circle.grid.2x2.fill"
    }
}

func drinkTint(for kind: DrinkKind) -> Color {
    switch kind {
    case .water: .blue
    case .coffee: .brown
    case .tea: .green
    case .other: .indigo
    }
}
