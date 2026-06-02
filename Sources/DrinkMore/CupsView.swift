import SwiftUI

struct CupsView: View {
    @EnvironmentObject private var store: AppStore
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
                        Button("编辑") {
                            draft = cup
                            editingCupID = cup.id
                        }
                        Button("删除", role: .destructive) {
                            store.deleteCup(cup)
                            if editingCupID == cup.id {
                                resetDraft()
                            }
                        }
                    }
                }
            }

            Form {
                Text(editingCupID == nil ? "新增杯子" : "编辑杯子")
                    .font(.headline)
                TextField("名称", text: $draft.name)
                Stepper("容量 \(draft.volumeML) ml", value: $draft.volumeML, in: 50...2000, step: 10)
                Picker("类型", selection: $draft.kind) {
                    ForEach(DrinkKind.allCases) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
                HStack {
                    Button("保存") {
                        let name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty else { return }
                        draft.name = name
                        store.upsertCup(draft)
                        resetDraft()
                    }
                    .keyboardShortcut(.defaultAction)
                    Button("新增杯子") {
                        resetDraft()
                    }
                    if let editingCupID, let cup = store.data.cups.first(where: { $0.id == editingCupID }) {
                        Button("删除杯子", role: .destructive) {
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
