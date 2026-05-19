import SwiftUI

struct GameView: View {
    let category: Category
    @EnvironmentObject var appState: AppState
    @StateObject private var vm: GameViewModel
    @ObservedObject private var audio = AudioService.shared
    @Environment(\.dismiss) private var dismiss

    init(category: Category) {
        self.category = category
        _vm = StateObject(wrappedValue: GameViewModel(category: category))
    }

    var body: some View {
        ZStack {
            Color(hex: "#0d0d1f")?.ignoresSafeArea() ?? Color.black.ignoresSafeArea()

            switch vm.phase {
            case .loading:
                loadingView
            case .playing, .revealed:
                gameContent
            case .finished:
                RoundResultView(
                    score: vm.totalScore,
                    correct: vm.correctCount,
                    total: vm.questions.count,
                    category: category,
                    scoreResponse: vm.scoreResponse
                )
            case .error(let msg):
                errorView(msg)
            }
        }
        .navigationBarHidden(true)
        .task { await vm.startRound() }
        .onDisappear { vm.cleanup() }
        .environment(\.layoutDirection, appState.language == .arabic ? .rightToLeft : .leftToRight)
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView().tint(.purple).scaleEffect(1.5)
            Text(appState.str("Loading questions…", "جاري تحميل الأسئلة…"))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    // MARK: - Error

    private func errorView(_ msg: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            Text(msg).foregroundStyle(.white.opacity(0.7)).multilineTextAlignment(.center)
            Button(appState.str("Try Again", "حاول مجددًا")) {
                Task { await vm.startRound() }
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
        .padding(32)
    }

    // MARK: - Main Game Content

    private var gameContent: some View {
        VStack(spacing: 0) {
            topBar
            Spacer(minLength: 12)
            audioSection
            Spacer(minLength: 20)
            answersSection
            Spacer(minLength: 24)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            VStack(spacing: 2) {
                Text(appState.str(
                    "\(vm.currentIndex + 1) / \(vm.questions.count)",
                    "\(vm.currentIndex + 1) / \(vm.questions.count)"
                ))
                .font(.headline)
                .foregroundStyle(.white)

                Text(category.displayName(for: appState.language))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            // Score badge
            VStack(spacing: 2) {
                Text("\(vm.totalScore)")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.yellow)
                    .contentTransition(.numericText())
                    .animation(.spring(), value: vm.totalScore)
                Text(appState.str("pts", "نقطة"))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.top, 56)
        .padding(.bottom, 12)
    }

    // MARK: - Audio Section (waveform + timer)

    private var audioSection: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )

                VStack(spacing: 16) {
                    // Waveform animation
                    // In mock mode there is no real audio, so animate whenever a question is active
                    WaveformView(isPlaying: waveformActive)
                        .frame(height: 60)

                    HStack(spacing: 16) {
                        // Replay button
                        Button {
                            if let q = vm.currentQuestion { audio.play(urlString: q.audioUrl) }
                        } label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.purple)
                        }
                        .opacity(audio.state == .finished || audio.state == .idle ? 1 : 0.4)
                        .disabled(audio.state == .playing || audio.state == .loading)

                        Spacer()

                        Text(appState.str("Listen carefully…", "استمع بعناية…"))
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.55))

                        Spacer()

                        // Timer ring
                        TimerRing(fraction: vm.timerFraction, seconds: vm.timeRemaining)
                    }
                }
                .padding(20)
            }
            .frame(height: 180)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08)).frame(height: 4)
                    Capsule()
                        .fill(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * vm.progressFraction, height: 4)
                        .animation(.easeInOut, value: vm.progressFraction)
                }
            }
            .frame(height: 4)
        }
    }

    // MARK: - Answers

    private var answersSection: some View {
        VStack(spacing: 12) {
            ForEach(Array(currentAnswers.enumerated()), id: \.offset) { idx, answer in
                AnswerButton(
                    label: answer.text(for: appState.language),
                    index: idx,
                    state: buttonState(for: idx),
                    action: { vm.selectAnswer(index: idx) }
                )
            }
        }
    }

    private var currentAnswers: [Answer] {
        vm.currentQuestion?.answers ?? []
    }

    private var waveformActive: Bool {
        audio.state == .playing
    }

    private func buttonState(for index: Int) -> AnswerButtonState {
        guard let selected = vm.selectedIndex else { return .normal }

        switch vm.phase {
        case .revealed(let state):
            switch state {
            case .correct(points: _) where selected == index:
                return .correct
            case .wrong(let correctIdx):
                if index == correctIdx  { return .correct }
                if index == selected    { return .wrong }
                return .dimmed
            case .expired:
                if index == vm.currentQuestion?.correctIndex { return .correct }
                return .dimmed
            default:
                return .dimmed
            }
        default:
            return selected == index ? .correct : .dimmed
        }
    }
}

// MARK: - Waveform Animation
// Uses TimelineView so the sine-wave phase advances every display frame — no timers needed.

struct WaveformView: View {
    let isPlaying: Bool
    private let barCount = 18

    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: !isPlaying)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            HStack(spacing: 4) {
                ForEach(0..<barCount, id: \.self) { i in
                    let h = isPlaying
                        ? abs(sin(t * 4.5 + Double(i) * 0.45)) * 42 + 8
                        : 6.0
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(colors: [.purple, .pink],
                                           startPoint: .bottom, endPoint: .top)
                        )
                        .frame(width: 4, height: CGFloat(h))
                }
            }
            .frame(maxWidth: .infinity)
            .animation(.easeInOut(duration: 0.3), value: isPlaying)
        }
    }
}
