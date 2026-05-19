import SwiftUI

struct RoundResultView: View {
    let score: Int
    let correct: Int
    let total: Int
    let category: Category
    let scoreResponse: ScoreResponse?

    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    private var accuracy: Int { total > 0 ? Int(Double(correct) / Double(total) * 100) : 0 }

    private var medal: String {
        switch accuracy {
        case 90...100: return "🥇"
        case 70..<90:  return "🥈"
        case 50..<70:  return "🥉"
        default:       return "🎯"
        }
    }

    private var gradeText: (String, String) {
        switch accuracy {
        case 90...100: return ("Excellent!", "ممتاز!")
        case 70..<90:  return ("Great Job!", "عمل رائع!")
        case 50..<70:  return ("Good Try!", "محاولة جيدة!")
        default:       return ("Keep Practicing!", "استمر في التدريب!")
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#0d0d1f")?.ignoresSafeArea() ?? Color.black.ignoresSafeArea()
            confettiBackground

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    Spacer(minLength: 60)

                    // Medal + grade
                    VStack(spacing: 12) {
                        Text(medal)
                            .font(.system(size: 80))
                        Text(appState.str(gradeText.0, gradeText.1))
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                    }

                    // Score card
                    VStack(spacing: 20) {
                        scoreRow(
                            icon: "star.fill", color: .yellow,
                            titleEn: "Total Score", titleAr: "مجموع النقاط",
                            value: "\(score) pts"
                        )
                        Divider().background(.white.opacity(0.15))
                        scoreRow(
                            icon: "checkmark.circle.fill", color: .green,
                            titleEn: "Correct Answers", titleAr: "إجابات صحيحة",
                            value: "\(correct) / \(total)"
                        )
                        Divider().background(.white.opacity(0.15))
                        scoreRow(
                            icon: "percent", color: .blue,
                            titleEn: "Accuracy", titleAr: "الدقة",
                            value: "\(accuracy)%"
                        )
                        if let sr = scoreResponse {
                            Divider().background(.white.opacity(0.15))
                            scoreRow(
                                icon: "trophy.fill", color: .orange,
                                titleEn: "Your Rank", titleAr: "ترتيبك",
                                value: "#\(sr.rank) / \(sr.totalPlayers)"
                            )
                        }
                    }
                    .padding(22)
                    .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.07)))
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    .padding(.horizontal, 20)

                    // Category label
                    Label(category.displayName(for: appState.language), systemImage: "tag")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.45))

                    // Buttons
                    VStack(spacing: 14) {
                        Button {
                            // Pops GameView → lands on CategorySelectionView
                            dismiss()
                        } label: {
                            Label(appState.str("Play Again", "العب مجددًا"), systemImage: "arrow.clockwise")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(colors: [.purple, .pink],
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }

                        Button {
                            // Signal HomeView to pop the entire stack
                            appState.shouldPopToRoot = true
                        } label: {
                            Label(appState.str("Home", "الرئيسية"), systemImage: "house")
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.white.opacity(0.08))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, appState.language == .arabic ? .rightToLeft : .leftToRight)
    }

    private func scoreRow(icon: String, color: Color, titleEn: String, titleAr: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 22)
            Text(appState.str(titleEn, titleAr))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
        }
    }

    private var confettiBackground: some View {
        ZStack {
            Circle()
                .fill(category.color.opacity(0.12))
                .frame(width: 350, height: 350)
                .blur(radius: 90)
                .offset(y: -180)
        }
        .ignoresSafeArea()
    }
}
