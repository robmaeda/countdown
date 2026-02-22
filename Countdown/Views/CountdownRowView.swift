import SwiftUI

struct CountdownRowView: View {
    let countdown: Countdown
    let referenceDate: Date

    private var interval: TimeInterval {
        CountdownFormatter.interval(to: countdown.targetDate)
    }

    private var directionText: String {
        countdown.targetDate > referenceDate ? "until" : "since"
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
