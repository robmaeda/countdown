import SwiftUI

private enum CountdownSheet: Identifiable {
    case add
    case edit(Countdown)
    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let c): return c.id.uuidString
        }
    }
}

struct CountdownListView: View {
    @ObservedObject var store: CountdownStore
    @State private var sheetItem: CountdownSheet?

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            NavigationStack {
                List {
                    ForEach(store.countdowns) { countdown in
                        Button {
                            sheetItem = .edit(countdown)
                        } label: {
                            CountdownRowView(countdown: countdown, referenceDate: context.date)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                store.delete(countdown)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("Countdowns")
                .safeAreaInset(edge: .bottom) {
                    Button {
                        sheetItem = .add
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .frame(width: 56, height: 56)
                            .contentShape(Circle())
                            .background(Circle().fill(.quaternary))
                    }
                    .buttonStyle(.plain)
                    .disabled(!store.canAddMore)
                    .frame(maxWidth: .infinity)
                }
                .sheet(item: $sheetItem, onDismiss: { sheetItem = nil }) { item in
                    switch item {
                    case .add:
                        AddEditCountdownView(store: store, editingCountdown: nil)
                    case .edit(let c):
                        AddEditCountdownView(store: store, editingCountdown: c)
                    }
                }
                .overlay {
                    if store.countdowns.isEmpty {
                        ContentUnavailableView(
                            "No countdowns",
                            systemImage: "clock.badge.questionmark",
                            description: Text("Tap + to add a countdown")
                        )
                    }
                }
            }
        }
    }
}
