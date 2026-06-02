import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case chinese = "zh-Hans"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .english: "English"
        case .chinese: "中文"
        }
    }
}

@MainActor
final class LanguageSettings: ObservableObject {
    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Self.storageKey)
        }
    }

    nonisolated private static let storageKey = "appLanguage"

    init() {
        let rawValue = UserDefaults.standard.string(forKey: Self.storageKey) ?? AppLanguage.english.rawValue
        language = AppLanguage(rawValue: rawValue) ?? .english
    }

    nonisolated static var current: AppLanguage {
        let rawValue = UserDefaults.standard.string(forKey: storageKey) ?? AppLanguage.english.rawValue
        return AppLanguage(rawValue: rawValue) ?? .english
    }
}

enum L10n {
    static func text(_ key: Key, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: english[key] ?? key.rawValue
        case .chinese: chinese[key] ?? key.rawValue
        }
    }

    static func drinkKind(_ kind: DrinkKind, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english:
            switch kind {
            case .water: "Water"
            case .coffee: "Coffee"
            case .tea: "Tea"
            case .other: "Other"
            }
        case .chinese:
            switch kind {
            case .water: "水"
            case .coffee: "咖啡"
            case .tea: "茶"
            case .other: "其他"
            }
        }
    }

    static func nextReminder(_ date: Date, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Next reminder \(date.formatted(date: .omitted, time: .shortened))"
        case .chinese: "下次提醒 \(date.formatted(date: .omitted, time: .shortened))"
        }
    }

    static func nextReminderFull(_ date: Date, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Next reminder: \(date.formatted(date: .abbreviated, time: .shortened))"
        case .chinese: "下次提醒：\(date.formatted(date: .abbreviated, time: .shortened))"
        }
    }

    static func cupSummary(volumeML: Int, count: Int, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "\(volumeML) ml · \(count) cup(s) today"
        case .chinese: "\(volumeML) ml · 今天 \(count) 杯"
        }
    }

    static func todayTotal(_ totalML: Int, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Today \(totalML) ml"
        case .chinese: "今天 \(totalML) ml"
        }
    }

    static func intervalMinutes(_ minutes: Int, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Countdown \(minutes) min"
        case .chinese: "倒计时 \(minutes) 分钟"
        }
    }

    static func fullScreenGrace(_ seconds: Int, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Full-screen reminder after \(seconds) sec"
        case .chinese: "通知后 \(seconds) 秒全屏提醒"
        }
    }

    static func capacity(_ volumeML: Int, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Capacity \(volumeML) ml"
        case .chinese: "容量 \(volumeML) ml"
        }
    }

    static func target(_ targetML: Int, _ language: AppLanguage = LanguageSettings.current) -> String {
        switch language {
        case .english: "Target \(targetML) ml"
        case .chinese: "目标 \(targetML) ml"
        }
    }

    enum Key: String {
        case today
        case cups
        case achievements
        case reminders
        case todayTotalIntake
        case todayLog
        case edit
        case delete
        case deleteCup
        case save
        case clear
        case addCup
        case editCup
        case cupName
        case type
        case goal
        case addAchievement
        case editAchievement
        case deleteAchievement
        case goalName
        case capacity
        case target
        case enableReminders
        case saveReminderSettings
        case testFullScreenReminder
        case language
        case snooze10
        case quit
        case timeToDrink
        case reminderBody
        case iDrank
        case fullScreenBody
        case acknowledged
    }

    private static let english: [Key: String] = [
        .today: "Today",
        .cups: "Cups",
        .achievements: "Personal Achievements",
        .reminders: "Reminders",
        .todayTotalIntake: "Total intake today",
        .todayLog: "Today's log",
        .edit: "Edit",
        .delete: "Delete",
        .deleteCup: "Delete cup",
        .save: "Save",
        .clear: "Clear",
        .addCup: "Add cup",
        .editCup: "Edit cup",
        .cupName: "Name",
        .type: "Type",
        .goal: "Goal",
        .addAchievement: "Add achievement",
        .editAchievement: "Edit achievement",
        .deleteAchievement: "Delete achievement",
        .goalName: "Name",
        .capacity: "Capacity",
        .target: "Target",
        .enableReminders: "Enable reminders",
        .saveReminderSettings: "Save reminder settings",
        .testFullScreenReminder: "Test full-screen reminder",
        .language: "Language",
        .snooze10: "Snooze 10 min",
        .quit: "Quit",
        .timeToDrink: "Time to drink",
        .reminderBody: "Take a sip and log it when you are done.",
        .iDrank: "I drank",
        .fullScreenBody: "Tap once after drinking so today's record stays accurate.",
        .acknowledged: "Done"
    ]

    private static let chinese: [Key: String] = [
        .today: "今天",
        .cups: "杯子",
        .achievements: "个人成就",
        .reminders: "提醒",
        .todayTotalIntake: "今天总摄入",
        .todayLog: "今日记录",
        .edit: "编辑",
        .delete: "删除",
        .deleteCup: "删除杯子",
        .save: "保存",
        .clear: "清空",
        .addCup: "新增杯子",
        .editCup: "编辑杯子",
        .cupName: "名称",
        .type: "类型",
        .goal: "目标",
        .addAchievement: "新增成就",
        .editAchievement: "编辑成就",
        .deleteAchievement: "删除成就",
        .goalName: "名称",
        .capacity: "容量",
        .target: "目标",
        .enableReminders: "开启提醒",
        .saveReminderSettings: "保存提醒设置",
        .testFullScreenReminder: "立刻测试全屏提醒",
        .language: "语言",
        .snooze10: "稍后 10 分钟",
        .quit: "退出",
        .timeToDrink: "该喝水了",
        .reminderBody: "起来喝一杯，顺手记录一下。",
        .iDrank: "我喝了",
        .fullScreenBody: "喝完点一下，今天的记录会更完整。",
        .acknowledged: "已处理"
    ]
}
