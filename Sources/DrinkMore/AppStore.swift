import Foundation

@MainActor
final class AppStore: ObservableObject {
    @Published private(set) var data: DrinkMoreData

    private let fileURL: URL
    private let calendar = Calendar.current

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = support.appendingPathComponent("DrinkMore", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        fileURL = folder.appendingPathComponent("drinkmore.json")

        if
            let raw = try? Data(contentsOf: fileURL),
            let decoded = try? JSONDecoder.drinkMore.decode(DrinkMoreData.self, from: raw)
        {
            data = decoded
        } else {
            data = .fresh
            save()
        }
    }

    var todayEntries: [DrinkEntry] {
        data.entries.filter { calendar.isDateInToday($0.date) }
    }

    var todayTotalML: Int {
        todayEntries.reduce(0) { $0 + $1.volumeML }
    }

    func todayTotal(for kind: DrinkKind) -> Int {
        todayEntries.filter { $0.kind == kind }.reduce(0) { $0 + $1.volumeML }
    }

    func todayCupCount(for cup: Cup) -> Int {
        todayEntries.filter { $0.cupID == cup.id }.count
    }

    func addDrink(cup: Cup) {
        data.entries.append(
            DrinkEntry(
                cupID: cup.id,
                cupName: cup.name,
                volumeML: cup.volumeML,
                kind: cup.kind,
                date: Date()
            )
        )
        save()
    }

    func removeEntry(_ entry: DrinkEntry) {
        data.entries.removeAll { $0.id == entry.id }
        save()
    }

    func upsertCup(_ cup: Cup) {
        if let index = data.cups.firstIndex(where: { $0.id == cup.id }) {
            data.cups[index] = cup
        } else {
            data.cups.append(cup)
        }
        save()
    }

    func deleteCup(_ cup: Cup) {
        data.cups.removeAll { $0.id == cup.id }
        save()
    }

    func updateReminder(_ reminder: ReminderSettings) {
        data.reminder = reminder
        save()
    }

    func upsertGoal(_ goal: AchievementGoal) {
        if let index = data.goals.firstIndex(where: { $0.id == goal.id }) {
            data.goals[index] = goal
        } else {
            data.goals.append(goal)
        }
        save()
    }

    func deleteGoal(_ goal: AchievementGoal) {
        data.goals.removeAll { $0.id == goal.id }
        save()
    }

    private func save() {
        if let encoded = try? JSONEncoder.drinkMore.encode(data) {
            try? encoded.write(to: fileURL, options: .atomic)
        }
    }
}

extension JSONEncoder {
    static var drinkMore: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

extension JSONDecoder {
    static var drinkMore: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
