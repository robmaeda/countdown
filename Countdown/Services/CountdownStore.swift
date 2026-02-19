import Foundation

/// Persists countdowns and enforces free (3) vs paid (10) limit.
final class CountdownStore: ObservableObject {
    static let freeLimit = 3
    static let paidLimit = 10

    @Published private(set) var countdowns: [Countdown] = []

    /// When true, user can have up to paidLimit countdowns and access premium features.
    /// Set via in-app purchase later; for now stored in UserDefaults.
    @Published var isPremium: Bool {
        didSet { UserDefaults.standard.set(isPremium, forKey: Self.premiumKey) }
    }

    private static let storageKey = "countdowns"
    private static let premiumKey = "isPremium"

    var countLimit: Int { isPremium ? Self.paidLimit : Self.freeLimit }
    var canAddMore: Bool { countdowns.count < countLimit }

    init() {
        self.isPremium = UserDefaults.standard.bool(forKey: Self.premiumKey)
        load()
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([Countdown].self, from: data) else {
            countdowns = []
            return
        }
        countdowns = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(countdowns) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    func add(_ countdown: Countdown) {
        guard canAddMore else { return }
        countdowns.append(countdown)
        save()
    }

    func update(_ countdown: Countdown) {
        guard let i = countdowns.firstIndex(where: { $0.id == countdown.id }) else { return }
        countdowns[i] = countdown
        save()
    }

    func delete(_ countdown: Countdown) {
        countdowns.removeAll { $0.id == countdown.id }
        save()
    }

    func delete(at offsets: IndexSet) {
        countdowns.remove(atOffsets: offsets)
        save()
    }
}
