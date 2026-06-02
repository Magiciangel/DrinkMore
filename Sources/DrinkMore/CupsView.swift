import SwiftUI

struct CupsView: View {
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var language: LanguageSettings
    @State private var draft = Cup(name: "", volumeML: 300, kind: .water)
    @State private var editingCupID: UUID?

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            List {
                ForEach(store.data.cups) { cup in
                    Button {
                        draft = cup
                        editingCupID = cup.id
                    } label: {
                        HStack {
                            Label(cup.name, systemImage: icon(for: cup.kind))
                            Spacer()
                            Text("\(cup.volumeML) ml")
                                .foregroundStyle(.secondary)
                            Image(systemName: editingCupID == cup.id ? "checkmark.circle.fill" : "chevron.right")
                                .foregroundStyle(editingCupID == cup.id ? Color.green : Color.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(L10n.text(.edit, language.language)) {
                            draft = cup
                            editingCupID = cup.id
                        }
                        Button(L10n.text(.delete, language.language), role: .destructive) {
                            store.deleteCup(cup)
                            if editingCupID == cup.id {
                                resetDraft()
                            }
                        }
                    }
                }
            }

            Form {
                Text(editingCupID == nil ? L10n.text(.addCup, language.language) : L10n.text(.editCup, language.language))
                    .font(.headline)
                TextField(L10n.text(.cupName, language.language), text: $draft.name)
                HStack {
                    Text(L10n.text(.capacity, language.language))
                    TextField("", value: $draft.volumeML, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 90)
                    Text("ml")
                        .foregroundStyle(.secondary)
                    Stepper("", value: $draft.volumeML, in: 50...2000, step: 10)
                        .labelsHidden()
                }
                Picker(L10n.text(.type, language.language), selection: $draft.kind) {
                    ForEach(DrinkKind.allCases) { kind in
                        Text(L10n.drinkKind(kind, language.language)).tag(kind)
                    }
                }
                HStack {
                    Button(L10n.text(.save, language.language)) {
                        let name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty else { return }
                        draft.name = name
                        draft.volumeML = min(max(draft.volumeML, 50), 2000)
                        store.upsertCup(draft)
                        resetDraft()
                    }
                    .keyboardShortcut(.defaultAction)
                    Button(L10n.text(.addCup, language.language)) {
                        resetDraft()
                    }
                    if let editingCupID, let cup = store.data.cups.first(where: { $0.id == editingCupID }) {
                        Button(L10n.text(.deleteCup, language.language), role: .destructive) {
                            store.deleteCup(cup)
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
        draft = Cup(name: "", volumeML: 300, kind: .water)
        editingCupID = nil
    }
}
