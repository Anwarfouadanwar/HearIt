import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL, noData
    case serverError(Int)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:          return "Invalid URL"
        case .noData:              return "No data"
        case .serverError(let c):  return "Server error \(c)"
        case .decodingError(let e): return e.localizedDescription
        }
    }
}

final class NetworkService {
    static let shared = NetworkService()

    // ── Replace with your actual backend URL when ready ──
    private let baseURL = "https://your-api.hearitapp.com/v1"

    // Set to false once the backend is live
    var useMockData = true

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    // MARK: - Categories

    func fetchCategories() async throws -> [Category] {
        if useMockData { return Category.mock }
        return try await get("/categories")
    }

    // MARK: - Questions

    func fetchQuestions(categoryId: String, count: Int = 10) async throws -> [Question] {
        if useMockData {
            return Array(Question.mock.shuffled().prefix(count))
        }
        return try await get("/questions?categoryId=\(categoryId)&count=\(count)")
    }

    // MARK: - Leaderboard

    func fetchLeaderboard(categoryId: String? = nil, limit: Int = 50) async throws -> [LeaderboardEntry] {
        if useMockData { return LeaderboardEntry.mock }
        var path = "/leaderboard?limit=\(limit)"
        if let id = categoryId { path += "&categoryId=\(id)" }
        return try await get(path)
    }

    // MARK: - Submit Score

    func submitScore(_ submission: ScoreSubmission) async throws -> ScoreResponse {
        if useMockData {
            return ScoreResponse(rank: Int.random(in: 1...200), totalPlayers: 3481)
        }
        return try await post("/scores", body: submission)
    }

    // MARK: - Helpers

    private func get<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: baseURL + path) else { throw NetworkError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        try validate(response)
        return try decode(T.self, from: data)
    }

    private func post<B: Encodable, T: Decodable>(_ path: String, body: B) async throws -> T {
        guard let url = URL(string: baseURL + path) else { throw NetworkError.invalidURL }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        let (data, response) = try await URLSession.shared.data(for: req)
        try validate(response)
        return try decode(T.self, from: data)
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.serverError(http.statusCode)
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do { return try decoder.decode(type, from: data) }
        catch { throw NetworkError.decodingError(error) }
    }
}
