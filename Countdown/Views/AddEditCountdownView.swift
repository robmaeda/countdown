import SwiftUI

struct AddEditCountdownView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: CountdownStore
    var onDismiss: (() -> Void)?

    var editingCountdown: Countdown?

    @State private var title: String = ""
    @State private var targetDate: Date = Date()
    @State private var displayMode: Countdown.DisplayMode = .full

    private var isEditing: Bool { editingCountdown != nil }

    /// When true, use a custom bar so the whole view (bar + form) animates together (e.g. scale from bottom).
    private var useInlineBar: Bool { onDismiss != nil }

    var body: some View {
        if useInlineBar {
            VStack(spacing: 0) {
                inlineBar
                formContent
            }
            .onAppear { loadEditing() }
        } else {
            NavigationStack {
                formContent
                    .navigationTitle(isEditing ? "Edit countdown" : "New countdown")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { performDismiss() }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") { save() }
                                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .onAppear { loadEditing() }
            }
        }
    }

    private var inlineBar: some View {
        HStack {
            Button("Cancel") { performDismiss() }
                .foregroundStyle(.primary)
            Spacer()
            Text(isEditing ? "Edit countdown" : "New countdown")
                .font(.headline)
            Spacer()
            Button("Save") { save() }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.bar)
    }

    private var formContent: some View {
        Form {
            Section("Title") {
                TextField("Event name", text: $title)
            }
            Section("Date") {
                DatePicker("Date", selection: $targetDate, displayedComponents: [.date, .hourAndMinute])
            }
            Section("Display") {
                Picker("Show", selection: $displayMode) {
                    ForEach(Countdown.DisplayMode.allCases, id: \.self) { mode in
                        Text(mode.label).tag(mode)
                    }
                }
            }
            if !store.isPremium {
                Section {
                    Button {
                        store.isPremium = true
                    } label: {
                        Label("Upgrade — more countdowns & widgets", systemImage: "star.fill")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }

    private func loadEditing() {
        if let c = editingCountdown {
            title = c.title
            targetDate = c.targetDate
            displayMode = c.displayMode
        }
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let existing = editingCountdown {
            var updated = existing
            updated.title = trimmed
            updated.targetDate = targetDate
            updated.displayMode = displayMode
            store.update(updated)
        } else {
            guard store.canAddMore else { return }
            let new = Countdown(
                title: trimmed,
                targetDate: targetDate,
                displayMode: displayMode
            )
            store.add(new)
        }
        performDismiss()
    }

    private func performDismiss() {
        if let onDismiss {
            onDismiss()
        } else {
            dismiss()
        }
    }
}
