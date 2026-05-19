import SwiftUI

@main
struct HearItApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appState)
                .environment(\.layoutDirection, appState.language == .arabic ? .rightToLeft : .leftToRight)
                .preferredColorScheme(.dark)
        }
    }
}
