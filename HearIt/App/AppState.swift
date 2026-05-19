import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case arabic  = "ar"

    var displayName: String {
        self == .arabic ? "العربية" : "English"
    }
}

final class AppState: ObservableObject {
    @Published var language: AppLanguage = .arabic
    @Published var playerName: String = ""
    // Set to true to pop the entire navigation stack back to HomeView
    @Published var shouldPopToRoot = false

    func str(_ en: String, _ ar: String) -> String {
        language == .arabic ? ar : en
    }
}
