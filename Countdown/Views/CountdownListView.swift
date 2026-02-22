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
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                sheetItem = .edit(countdown)
                            }
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
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            sheetItem = .add
                        }
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
                .overlay {
                    if let item = sheetItem {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    sheetItem = nil
                                }
                            }
                        sheetContent(for: item)
                            .compositingGroup()
                            .transition(.scale(scale: 0.3, anchor: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: sheetItem?.id)
                .id(sheetItem == nil)
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

    private func dismissSheet() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            sheetItem = nil
        }
    }

    @ViewBuilder
    private func sheetContent(for item: CountdownSheet) -> some View {
        switch item {
        case .add:
            AddEditCountdownView(store: store, onDismiss: dismissSheet, editingCountdown: nil)
        case .edit(let c):
            AddEditCountdownView(store: store, onDismiss: dismissSheet, editingCountdown: c)
        }
    }
}
