import Foundation

enum DrinkKind: String, Codable, CaseIterable, Identifiable {
    case water
    case coffee
    case tea
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .water: "水"
        case .coffee: "咖啡"
        case .tea: "茶"
        case .other: "其他"
        }
    }
}

struct Cup: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var volumeML: Int
    var kind: DrinkKind
}

struct DrinkEntry: Identifiable, Codable, Equatable {
    var id = UUID()
    var cupID: UUID
    var cupName: String
    var volumeML: Int
    var kind: DrinkKind
    var date: Date
}

struct ReminderSettings: Codable, Equatable {
    var isEnabled = true
    var intervalMinutes = 45
    var fullScreenGraceSeconds = 90
}

struct AchievementGoal: Identifiable, Codable, Equatable {
    var id = UUID()
    var kind: DrinkKind
    var title: String
    var targetML: Int
}

struct DrinkMoreData: Codable, Equatable {
    var cups: [Cup]
    var entries: [DrinkEntry]
    var reminder: ReminderSettings
    var goals: [AchievementGoal]

    static let fresh = DrinkMoreData(
        cups: [
            Cup(name: "水杯", volumeML: 350, kind: .water),
            Cup(name: "咖啡杯", volumeML: 240, kind: .coffee),
            Cup(name: "马克杯", volumeML: 300, kind: .water),
            Cup(name: "随行杯", volumeML: 500, kind: .water)
        ],
        entries: [],
        reminder: ReminderSettings(),
        goals: [
            AchievementGoal(kind: .water, title: "今日饮水", targetML: 1800),
            AchievementGoal(kind: .coffee, title: "咖啡上限", targetML: 480)
        ]
    )
}
