import SwiftUI

enum AnswerButtonState {
    case normal
    case correct
    case wrong
    case dimmed   // other buttons when one is selected
}

struct AnswerButton: View {
    let label: String
    let index: Int
    let state: AnswerButtonState
    let action: () -> Void

    private var background: some ShapeStyle {
        switch state {
        case .normal:
            return AnyShapeStyle(
                LinearGradient(colors: [Color.white.opacity(0.10), Color.white.opacity(0.05)],
                               startPoint: .top, endPoint: .bottom)
            )
        case .correct:
            return AnyShapeStyle(Color.green.opacity(0.85))
        case .wrong:
            return AnyShapeStyle(Color.red.opacity(0.75))
        case .dimmed:
            return AnyShapeStyle(Color.white.opacity(0.04))
        }
    }

    private var borderColor: Color {
        switch state {
        case .normal:  return .white.opacity(0.15)
        case .correct: return .green
        case .wrong:   return .red
        case .dimmed:  return .white.opacity(0.06)
        }
    }

    private var textColor: Color {
        switch state {
        case .dimmed: return .white.opacity(0.35)
        default:      return .white
        }
    }

    private var icon: String? {
        switch state {
        case .correct: return "checkmark.circle.fill"
        case .wrong:   return "xmark.circle.fill"
        default:       return nil
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Answer letter badge
                ZStack {
                    Circle()
                        .fill(.white.opacity(state == .dimmed ? 0.05 : 0.15))
                        .frame(width: 34, height: 34)
                    Text(["A","B","C","D"][index])
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(textColor)
                }

                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let icon {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(state == .correct ? Color.green : .red)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .disabled(state != .normal)
        .animation(.easeOut(duration: 0.25), value: state)
    }
}
