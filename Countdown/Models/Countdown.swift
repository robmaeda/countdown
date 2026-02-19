import Foundation

/// A single countdown (or count-up) to a date.
struct Countdown: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var targetDate: Date
    var isCountUp: Bool
    var displayMode: DisplayMode

    init(
        id: UUID = UUID(),
        title: String,
        targetDate: Date,
        isCountUp: Bool = false,
        displayMode: DisplayMode = .full
    ) {
        self.id = id
        self.title = title
        self.targetDate = targetDate
        self.isCountUp = isCountUp
        self.displayMode = displayMode
    }

    enum DisplayMode: String, Codable, CaseIterable {
        case dayOnly
        case hoursOnly
        case full

        var label: String {
            switch self {
            case .dayOnly: return "Days only"
            case .hoursOnly: return "Days & hours"
            case .full: return "Full (days, hrs, min, sec)"
            }
        }
    }
}
