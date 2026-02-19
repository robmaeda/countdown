import SwiftUI

struct CountdownRowView: View {
    let countdown: Countdown
    let referenceDate: Date

    private var interval: TimeInterval {
        CountdownFormatter.interval(to: countdown.targetDate, isCountUp: countdown.isCountUp)
    }

    private var directionText: String {
        countdown.isCountUp ? "since" : "until"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(countdown.title)
                .font(.headline)
            Text(CountdownFormatter.format(interval: interval, displayMode: countdown.displayMode))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(directionText)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}
