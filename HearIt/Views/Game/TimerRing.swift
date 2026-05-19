import SwiftUI

struct TimerRing: View {
    let fraction: Double   // 1.0 = full, 0.0 = empty
    let seconds: Int

    private var ringColor: Color {
        switch fraction {
        case 0.6...1.0: return .green
        case 0.3..<0.6: return .orange
        default:        return .red
        }
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 8)

            // Progress arc
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: fraction)

            // Number
            VStack(spacing: 2) {
                Text("\(seconds)")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.linear(duration: 0.2), value: seconds)

                Text("sec")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(width: 88, height: 88)
    }
}
