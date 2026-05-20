import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL, noData
    case serverError(Int)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:           return "Invalid URL"
        case .noData:               return "No data"
        case .serverError(let c):   return "Server error \(c)"
        case .decodingError(let e): return e.localizedDescription
        }
    }
}

final class NetworkService {
    static let shared = NetworkService()

    // ── Supabase credentials ─────────────────────────────────────────────────
    // 1. Create a project at https://supabase.com
    // 2. Go to Project Settings → API
    // 3. Copy "Project URL" and "anon public" key below
    // 4. Set useMockData = false
    private let supabaseURL = "https://YOUR_PROJECT_ID.supabase.co"
    private let anonKey     = "YOUR_ANON_KEY"

    var useMockData = true

    private var restURL: String { "\(supabaseURL)/rest/v1" }

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy  = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }()

    // MARK: - Categories

    func fetchCategories() async throws -> [Category] {
        if useMockData { return Category.mock }
        return try await get("/categories?select=*&order=name_en.asc")
    }

    // MARK: - Questions

    func fetchQuestions(categoryId: String, count: Int = 10) async throws -> [Question] {
        if useMockData { return Array(Question.mock.shuffled().prefix(count)) }
        let path = "/questions?select=*,answers(*)&category_id=eq.\(categoryId)&answers.order=sort_order.asc&limit=\(count)"
        return try await get(path)
    }

    // MARK: - Leaderboard

    func fetchLeaderboard(categoryId: String? = nil, limit: Int = 50) async throws -> [LeaderboardEntry] {
        if useMockData { return LeaderboardEntry.mock }
        var path = "/leaderboard?select=*&order=rank.asc&limit=\(limit)"
        if let id = categoryId { path += "&category_id=eq.\(id)" }
        return try await get(path)
    }

    // MARK: - Submit Score

    func submitScore(_ submission: ScoreSubmission) async throws -> ScoreResponse {
        if useMockData { return ScoreResponse(rank: Int.random(in: 1...200), totalPlayers: 3481) }
        return try await rpc("submit_score", body: submission)
    }

    // MARK: - Helpers

    private func request(_ path: String, method: String = "GET") throws -> URLRequest {
        guard let url = URL(string: restURL + path) else { throw NetworkError.invalidURL }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue(anonKey,             forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json",  forHTTPHeaderField: "Content-Type")
        return req
    }

    private func get<T: Decodable>(_ path: String) async throws -> T {
        let req = try request(path)
        let (data, response) = try await URLSession.shared.data(for: req)
        try validate(response)
        return try decode(T.self, from: data)
    }

    private func rpc<B: Encodable, T: Decodable>(_ name: String, body: B) async throws -> T {
        var req = try request("/rpc/\(name)", method: "POST")
        req.httpBody = try encoder.encode(body)
        let (data, response) = try await URLSession.shared.data(for: req)
        try validate(response)
        return try decode(T.self, from: data)
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              !(200...299).contains(http.statusCode) else { return }
        throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? 0)
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do { return try decoder.decode(type, from: data) }
        catch { throw NetworkError.decodingError(error) }
    }
}
