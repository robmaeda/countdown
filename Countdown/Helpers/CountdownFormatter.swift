import Foundation

enum CountdownFormatter {
    /// Returns a string like "3 days" or "2 days, 5 hr" or "1 day, 2 hr, 30 min, 45 sec" based on display mode.
    /// For count-up, the interval is from targetDate to now; for count-down, from now to targetDate.
    static func format(interval: TimeInterval, displayMode: Countdown.DisplayMode) -> String {
        let absInterval = abs(interval)
        let seconds = Int(absInterval) % 60
        let minutes = (Int(absInterval) / 60) % 60
        let hours = (Int(absInterval) / 3600) % 24
        let days = Int(absInterval) / 86400

        let dayStr = days == 1 ? "day" : "days"
        let hourStr = hours == 1 ? "hr" : "hr"
        let minStr = minutes == 1 ? "min" : "min"
        let secStr = seconds == 1 ? "sec" : "sec"

        switch displayMode {
        case .dayOnly:
            return "\(days) \(dayStr)"
        case .hoursOnly:
            if days > 0 {
                return "\(days) \(dayStr), \(hours) \(hourStr)"
            }
            return "\(hours) \(hourStr)"
        case .full:
            if days > 0 {
                return "\(days) \(dayStr), \(hours) \(hourStr), \(minutes) \(minStr), \(seconds) \(secStr)"
            }
            if hours > 0 {
                return "\(hours) \(hourStr), \(minutes) \(minStr), \(seconds) \(secStr)"
            }
            if minutes > 0 {
                return "\(minutes) \(minStr), \(seconds) \(secStr)"
            }
            return "\(seconds) \(secStr)"
        }
    }

    /// Interval from now to targetDate. Positive = future (count down), negative = past (count up).
    static func interval(to targetDate: Date) -> TimeInterval {
        targetDate.timeIntervalSinceNow
    }
}
