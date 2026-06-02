import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var reminder: ReminderEngine

    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("今天", systemImage: "drop.fill") }
            CupsView()
                .tabItem { Label("杯子", systemImage: "mug.fill") }
            AchievementsView()
                .tabItem { Label("成就", systemImage: "medal.fill") }
            SettingsView()
                .tabItem { Label("提醒", systemImage: "timer") }
        }
        .frame(minWidth: 820, minHeight: 560)
        .padding(16)
        .onChange(of: store.data.reminder) { _, _ in
            reminder.reschedule()
        }
    }
}
