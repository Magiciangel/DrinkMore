import Foundation

enum DrinkKind: String, Codable, CaseIterable, Identifiable {
    case water
    case coffee
    case tea
    case other

    var id: String { rawValue }

    var title: String {
        L10n.drinkKind(self)
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
            Cup(name: "Water glass", volumeML: 350, kind: .water),
            Cup(name: "Coffee cup", volumeML: 240, kind: .coffee),
            Cup(name: "Mug", volumeML: 300, kind: .water),
            Cup(name: "Travel bottle", volumeML: 500, kind: .water)
        ],
        entries: [],
        reminder: ReminderSettings(),
        goals: [
            AchievementGoal(kind: .water, title: "Daily water", targetML: 1800),
            AchievementGoal(kind: .coffee, title: "Coffee limit", targetML: 480)
        ]
    )
}
