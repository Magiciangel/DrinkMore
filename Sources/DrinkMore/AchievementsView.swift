import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var draft = AchievementGoal(kind: .water, title: "", targetML: 1800)

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(store.data.goals) { goal in
                    let current = store.todayTotal(for: goal.kind)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label(goal.title, systemImage: icon(for: goal.kind))
                            Spacer()
                            Text("\(current) / \(goal.targetML) ml")
                                .foregroundStyle(.secondary)
                        }
                        ProgressView(value: min(Double(current) / Double(max(goal.targetML, 1)), 1))
                            .tint(current >= goal.targetML ? .green : drinkTint(for: goal.kind))
                    }
                    .padding(12)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                    .contextMenu {
                        Button("编辑") { draft = goal }
                        Button("删除", role: .destructive) { store.deleteGoal(goal) }
                    }
                }
                Spacer()
            }

            Form {
                Text("目标")
                    .font(.headline)
                TextField("名称", text: $draft.title)
                Picker("类型", selection: $draft.kind) {
                    ForEach(DrinkKind.allCases) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
                Stepper("目标 \(draft.targetML) ml", value: $draft.targetML, in: 50...5000, step: 50)
                HStack {
                    Button("保存") {
                        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !title.isEmpty else { return }
                        draft.title = title
                        store.upsertGoal(draft)
                        draft = AchievementGoal(kind: .water, title: "", targetML: 1800)
                    }
                    .keyboardShortcut(.defaultAction)
                    Button("清空") {
                        draft = AchievementGoal(kind: .water, title: "", targetML: 1800)
                    }
                }
            }
            .formStyle(.grouped)
            .frame(width: 280)
        }
    }
}
