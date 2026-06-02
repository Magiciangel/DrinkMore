import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine
    @EnvironmentObject private var language: LanguageSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(store.todayTotalML) ml")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                Text(L10n.text(.todayTotalIntake, language.language))
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Spacer()
                if let next = reminder.nextReminderAt {
                    Text(L10n.nextReminder(next, language.language))
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
                            Text(L10n.cupSummary(volumeML: cup.volumeML, count: store.todayCupCount(for: cup), language.language))
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

            Text(L10n.text(.todayLog, language.language))
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
                        Button(L10n.text(.delete, language.language)) {
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
