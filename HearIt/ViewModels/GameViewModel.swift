import SwiftUI
import Combine
import UIKit

enum AnswerState {
    case unanswered
    case correct(points: Int)
    case wrong(correctIndex: Int)
    case expired
}

enum GamePhase: Equatable {
    case loading
    case playing
    case revealed(AnswerState)
    case finished
    case error(String)

    static func == (lhs: GamePhase, rhs: GamePhase) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.playing, .playing), (.finished, .finished): return true
        case (.revealed, .revealed), (.error, .error): return true
        default: return false
        }
    }
}

@MainActor
final class GameViewModel: ObservableObject {
    // Game state
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var phase: GamePhase = .loading
    @Published var timeRemaining: Int = 30
    @Published var totalScore: Int = 0
    @Published var correctCount: Int = 0
    @Published var selectedIndex: Int? = nil

    // Post-round
    @Published var isSubmitting = false
    @Published var scoreResponse: ScoreResponse? = nil

    let category: Category
    let questionsPerRound: Int

    private var timerTask: Task<Void, Never>? = nil
    private let network = NetworkService.shared
    private let audio = AudioService.shared

    init(category: Category, questionsPerRound: Int = 10) {
        self.category = category
        self.questionsPerRound = questionsPerRound
    }

    // MARK: - Computed

    var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var progressFraction: Double {
        questions.isEmpty ? 0 : Double(currentIndex) / Double(questions.count)
    }

    var timerFraction: Double {
        Double(timeRemaining) / 30.0
    }

    // MARK: - Lifecycle

    func startRound() async {
        phase = .loading
        do {
            let fetched = try await network.fetchQuestions(
                categoryId: category.id,
                count: questionsPerRound
            )
            questions = fetched.shuffled()
            loadCurrentQuestion()
        } catch {
            phase = .error(error.localizedDescription)
        }
    }

    private func loadCurrentQuestion() {
        guard currentIndex < questions.count else { endRound(); return }
        selectedIndex = nil
        timeRemaining = 30
        phase = .playing
        // Only attempt real audio streaming when not in mock mode
        if !NetworkService.shared.useMockData, let q = currentQuestion {
            audio.play(urlString: q.audioUrl)
        }
        startTimer()
    }

    // MARK: - Timer

    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task {
            while timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                timeRemaining -= 1
            }
            if !Task.isCancelled { onTimeExpired() }
        }
    }

    private func onTimeExpired() {
        audio.stop()
        selectedIndex = -1
        phase = .revealed(.expired)
        scheduleNextQuestion(delay: 2.5)
    }

    // MARK: - User Input

    func selectAnswer(index: Int) {
        guard case .playing = phase, selectedIndex == nil else { return }
        timerTask?.cancel()
        audio.stop()
        selectedIndex = index

        guard let q = currentQuestion else { return }
        if index == q.correctIndex {
            let pts = timeRemaining
            totalScore += pts
            correctCount += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            phase = .revealed(.correct(points: pts))
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            phase = .revealed(.wrong(correctIndex: q.correctIndex))
        }
        scheduleNextQuestion(delay: 2.5)
    }

    private func scheduleNextQuestion(delay: Double) {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            if !Task.isCancelled {
                currentIndex += 1
                loadCurrentQuestion()
            }
        }
    }

    // MARK: - End of Round

    private func endRound() {
        phase = .finished
        Task { await submitScore() }
    }

    private func submitScore() async {
        guard !NetworkService.shared.useMockData else { return }
        isSubmitting = true
        let submission = ScoreSubmission(
            playerName: "Player",
            categoryId: category.id,
            score: totalScore,
            questionsAnswered: correctCount
        )
        do {
            scoreResponse = try await network.submitScore(submission)
        } catch {}
        isSubmitting = false
    }

    func cleanup() {
        timerTask?.cancel()
        audio.stop()
    }
}
