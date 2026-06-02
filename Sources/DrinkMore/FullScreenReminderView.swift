import SwiftUI

struct FullScreenReminderView: View {
    var onDrink: () -> Void
    var onSnooze: () -> Void
    private let language = LanguageSettings.current

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.18, blue: 0.26), Color(red: 0.05, green: 0.38, blue: 0.48)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 26) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 86))
                    .foregroundStyle(.white)
                Text(L10n.text(.timeToDrink, language))
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(L10n.text(.fullScreenBody, language))
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.82))

                HStack(spacing: 16) {
                    Button(L10n.text(.iDrank, language)) { onDrink() }
                        .font(.title3.bold())
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    Button(L10n.text(.snooze10, language)) { onSnooze() }
                        .font(.title3)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }
            }
        }
    }
}
