import Foundation

struct LeaderboardEntry: Codable, Identifiable {
    let id: String
    let rank: Int
    let playerName: String
    let score: Int
    let categoryId: String
    let questionsAnswered: Int
    let createdAt: Date

    static let mock: [LeaderboardEntry] = [
        LeaderboardEntry(id: "l1", rank: 1, playerName: "Ahmed",   score: 285, categoryId: "arab-singers", questionsAnswered: 10, createdAt: Date()),
        LeaderboardEntry(id: "l2", rank: 2, playerName: "Sara",    score: 261, categoryId: "arab-singers", questionsAnswered: 10, createdAt: Date()),
        LeaderboardEntry(id: "l3", rank: 3, playerName: "Mohamed", score: 247, categoryId: "arab-singers", questionsAnswered: 9,  createdAt: Date()),
        LeaderboardEntry(id: "l4", rank: 4, playerName: "Layla",   score: 230, categoryId: "arab-singers", questionsAnswered: 10, createdAt: Date()),
        LeaderboardEntry(id: "l5", rank: 5, playerName: "Khalid",  score: 218, categoryId: "arab-singers", questionsAnswered: 8,  createdAt: Date()),
        LeaderboardEntry(id: "l6", rank: 6, playerName: "Nour",    score: 205, categoryId: "arab-singers", questionsAnswered: 10, createdAt: Date()),
        LeaderboardEntry(id: "l7", rank: 7, playerName: "Yousef",  score: 193, categoryId: "arab-singers", questionsAnswered: 7,  createdAt: Date()),
    ]
}

struct ScoreSubmission: Codable {
    let playerName: String
    let categoryId: String
    let score: Int
    let questionsAnswered: Int
}

struct ScoreResponse: Codable {
    let rank: Int
    let totalPlayers: Int
}
