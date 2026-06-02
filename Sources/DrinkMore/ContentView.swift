import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine
    @EnvironmentObject private var language: LanguageSettings
    @State private var selectedTab: AppTab = .today

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(AppTab.allCases) { tab in
                    Button {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
                            selectedTab = tab
                        }
                    } label: {
                        Label(tab.title(language.language), systemImage: tab.systemImage)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(selectedTab == tab ? .blue : .gray.opacity(0.32))
                    .foregroundStyle(selectedTab == tab ? .white : .primary)
                }
            }

            ZStack {
                selectedView
                    .id(selectedTab)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
            }
            .animation(.spring(response: 0.32, dampingFraction: 0.88), value: selectedTab)
        }
        .frame(minWidth: 820, minHeight: 560)
        .padding(16)
        .onChange(of: store.data.reminder) { _, _ in
            reminder.reschedule()
        }
    }

    @ViewBuilder
    private var selectedView: some View {
        switch selectedTab {
        case .today:
            TodayView()
        case .cups:
            CupsView()
        case .achievements:
            AchievementsView()
        case .reminders:
            SettingsView()
        }
    }
}

enum AppTab: CaseIterable, Identifiable {
    case today
    case cups
    case achievements
    case reminders

    var id: Self { self }

    var systemImage: String {
        switch self {
        case .today: "drop.fill"
        case .cups: "mug.fill"
        case .achievements: "medal.fill"
        case .reminders: "timer"
        }
    }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .today: L10n.text(.today, language)
        case .cups: L10n.text(.cups, language)
        case .achievements: L10n.text(.achievements, language)
        case .reminders: L10n.text(.reminders, language)
        }
    }
}
