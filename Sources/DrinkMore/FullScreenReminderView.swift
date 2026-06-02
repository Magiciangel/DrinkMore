import SwiftUI

struct FullScreenReminderView: View {
    var onDrink: () -> Void
    var onSnooze: () -> Void

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
                Text("该喝水了")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("喝完点一下，今天的记录会更完整。")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.82))

                HStack(spacing: 16) {
                    Button("我喝了") { onDrink() }
                        .font(.title3.bold())
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    Button("稍后 10 分钟") { onSnooze() }
                        .font(.title3)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }
            }
        }
    }
}
