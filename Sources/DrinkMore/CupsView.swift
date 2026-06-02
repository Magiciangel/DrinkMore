import SwiftUI

struct CupsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var draft = Cup(name: "", volumeML: 300, kind: .water)

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            List {
                ForEach(store.data.cups) { cup in
                    HStack {
                        Label(cup.name, systemImage: icon(for: cup.kind))
                        Spacer()
                        Text("\(cup.volumeML) ml")
                            .foregroundStyle(.secondary)
                    }
                    .contextMenu {
                        Button("编辑") { draft = cup }
                        Button("删除", role: .destructive) { store.deleteCup(cup) }
                    }
                }
            }

            Form {
                Text("杯子")
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
                        draft = Cup(name: "", volumeML: 300, kind: .water)
                    }
                    .keyboardShortcut(.defaultAction)
                    Button("清空") {
                        draft = Cup(name: "", volumeML: 300, kind: .water)
                    }
                }
            }
            .formStyle(.grouped)
            .frame(width: 280)
        }
    }
}
