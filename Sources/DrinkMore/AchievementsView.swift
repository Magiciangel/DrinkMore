import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var language: LanguageSettings
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
                        Button(L10n.text(.edit, language.language)) { draft = goal }
                        Button(L10n.text(.delete, language.language), role: .destructive) { store.deleteGoal(goal) }
                    }
                }
                Spacer()
            }

            Form {
                Text(L10n.text(.goal, language.language))
                    .font(.headline)
                TextField(L10n.text(.goalName, language.language), text: $draft.title)
                Picker(L10n.text(.type, language.language), selection: $draft.kind) {
                    ForEach(DrinkKind.allCases) { kind in
                        Text(L10n.drinkKind(kind, language.language)).tag(kind)
                    }
                }
                Stepper(L10n.target(draft.targetML, language.language), value: $draft.targetML, in: 50...5000, step: 50)
                HStack {
                    Button(L10n.text(.save, language.language)) {
                        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !title.isEmpty else { return }
                        draft.title = title
                        store.upsertGoal(draft)
                        draft = AchievementGoal(kind: .water, title: "", targetML: 1800)
                    }
                    .keyboardShortcut(.defaultAction)
                    Button(L10n.text(.clear, language.language)) {
                        draft = AchievementGoal(kind: .water, title: "", targetML: 1800)
                    }
                }
            }
            .formStyle(.grouped)
            .frame(width: 280)
        }
    }
}
