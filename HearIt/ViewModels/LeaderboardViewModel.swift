import Foundation

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var isLoading = false
    @Published var error: String? = nil

    private let network = NetworkService.shared

    func load(categoryId: String? = nil) async {
        isLoading = true
        error = nil
        do {
            entries = try await network.fetchLeaderboard(categoryId: categoryId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
