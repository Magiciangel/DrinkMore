import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var language: LanguageSettings
    @State private var draft = AchievementGoal(kind: .water, title: "", targetML: 1800)
    @State private var editingGoalID: UUID?

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(store.data.goals) { goal in
                    let current = store.todayTotal(for: goal.kind)
                    Button {
                        draft = goal
                        editingGoalID = goal.id
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Label(goal.title, systemImage: icon(for: goal.kind))
                                Spacer()
                                Text("\(current) / \(goal.targetML) ml")
                                    .foregroundStyle(.secondary)
                                Image(systemName: editingGoalID == goal.id ? "checkmark.circle.fill" : "chevron.right")
                                    .foregroundStyle(editingGoalID == goal.id ? Color.green : Color.secondary)
                            }
                            ProgressView(value: min(Double(current) / Double(max(goal.targetML, 1)), 1))
                                .tint(current >= goal.targetML ? .green : drinkTint(for: goal.kind))
                        }
                        .padding(12)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(L10n.text(.edit, language.language)) {
                            draft = goal
                            editingGoalID = goal.id
                        }
                        Button(L10n.text(.delete, language.language), role: .destructive) {
                            store.deleteGoal(goal)
                            if editingGoalID == goal.id {
                                resetDraft()
                            }
                        }
                    }
                }
                Spacer()
            }

            Form {
                Text(editingGoalID == nil ? L10n.text(.addAchievement, language.language) : L10n.text(.editAchievement, language.language))
                    .font(.headline)
                TextField(L10n.text(.goalName, language.language), text: $draft.title)
                Picker(L10n.text(.type, language.language), selection: $draft.kind) {
                    ForEach(DrinkKind.allCases) { kind in
                        Text(L10n.drinkKind(kind, language.language)).tag(kind)
                    }
                }
                HStack {
                    Text(L10n.text(.target, language.language))
                    TextField("", value: $draft.targetML, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 90)
                    Text("ml")
                        .foregroundStyle(.secondary)
                    Stepper("", value: $draft.targetML, in: 50...5000, step: 50)
                        .labelsHidden()
                }
                HStack {
                    Button(L10n.text(.save, language.language)) {
                        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !title.isEmpty else { return }
                        draft.title = title
                        draft.targetML = min(max(draft.targetML, 50), 5000)
                        store.upsertGoal(draft)
                        resetDraft()
                    }
                    .keyboardShortcut(.defaultAction)
                    Button(L10n.text(.addAchievement, language.language)) {
                        resetDraft()
                    }
                    if let editingGoalID, let goal = store.data.goals.first(where: { $0.id == editingGoalID }) {
                        Button(L10n.text(.deleteAchievement, language.language), role: .destructive) {
                            store.deleteGoal(goal)
                            resetDraft()
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .frame(width: 280)
        }
    }

    private func resetDraft() {
        draft = AchievementGoal(kind: .water, title: "", targetML: 1800)
        editingGoalID = nil
    }
}
