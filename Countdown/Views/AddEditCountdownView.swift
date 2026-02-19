import SwiftUI

struct AddEditCountdownView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: CountdownStore

    var editingCountdown: Countdown?

    @State private var title: String = ""
    @State private var targetDate: Date = Date()
    @State private var isCountUp: Bool = false
    @State private var displayMode: Countdown.DisplayMode = .full

    private var isEditing: Bool { editingCountdown != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Event name", text: $title)
                }
                Section("Date") {
                    DatePicker("Date", selection: $targetDate, displayedComponents: [.date, .hourAndMinute])
                }
                Section("Direction") {
                    Picker("Direction", selection: $isCountUp) {
                        Text("Count down").tag(false)
                        Text("Count up").tag(true)
                    }
                    .pickerStyle(.segmented)
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
                            // TODO: present paywall / IAP
                            store.isPremium = true
                        } label: {
                            Label("Upgrade — more countdowns & widgets", systemImage: "star.fill")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit countdown" : "New countdown")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { loadEditing() }
        }
    }

    private func loadEditing() {
        if let c = editingCountdown {
            title = c.title
            targetDate = c.targetDate
            isCountUp = c.isCountUp
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
            updated.isCountUp = isCountUp
            updated.displayMode = displayMode
            store.update(updated)
        } else {
            guard store.canAddMore else { return }
            let new = Countdown(
                title: trimmed,
                targetDate: targetDate,
                isCountUp: isCountUp,
                displayMode: displayMode
            )
            store.add(new)
        }
        dismiss()
    }
}
