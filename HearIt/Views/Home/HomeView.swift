import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var playerName = ""
    @State private var showNameAlert = false
    @State private var goToCategories = false
    @State private var goToLeaderboard = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0

    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack(spacing: 0) {
                    Spacer()
                    logo
                    Spacer()
                    buttons
                        .padding(.horizontal, 28)
                    languagePicker
                        .padding(.top, 24)
                    Spacer(minLength: 48)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToCategories) {
                CategorySelectionView()
            }
            .navigationDestination(isPresented: $goToLeaderboard) {
                LeaderboardView(categoryId: nil)
            }
        }
        .alert(appState.str("Your Name", "اسم اللاعب"), isPresented: $showNameAlert) {
            TextField(appState.str("Enter your name", "أدخل اسمك"), text: $playerName)
            Button(appState.str("Let's Go!", "انطلق!")) {
                appState.playerName = playerName.trimmingCharacters(in: .whitespaces).isEmpty
                    ? appState.str("Player", "لاعب")
                    : playerName
                goToCategories = true
            }
            Button(appState.str("Cancel", "إلغاء"), role: .cancel) {}
        }
        .environment(\.layoutDirection, appState.language == .arabic ? .rightToLeft : .leftToRight)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1
                logoOpacity = 1
            }
        }
        // When any child signals "go home", pop the whole stack
        .onChange(of: appState.shouldPopToRoot) { _, reset in
            if reset {
                goToCategories = false
                goToLeaderboard = false
                appState.shouldPopToRoot = false
            }
        }
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0d0d1f") ?? .black,
                         Color(hex: "#1a0533") ?? .purple.opacity(0.4),
                         Color(hex: "#0d0d1f") ?? .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(Color.purple.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -80, y: -160)
            Circle()
                .fill(Color.pink.opacity(0.12))
                .frame(width: 250, height: 250)
                .blur(radius: 70)
                .offset(x: 100, y: 200)
        }
        .ignoresSafeArea()
    }

    // MARK: - Logo

    private var logo: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.purple, .pink],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 130, height: 130)
                    .shadow(color: .purple.opacity(0.7), radius: 30)

                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)

            VStack(spacing: 8) {
                Text("HearIt")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, .purple.opacity(0.9)],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )

                Text(appState.str("Guess the sound. Earn the points.", "خمّن الصوت. افوز بالنقاط."))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .opacity(logoOpacity)
        }
    }

    // MARK: - Buttons

    private var buttons: some View {
        VStack(spacing: 14) {
            Button { showNameAlert = true } label: {
                Label(appState.str("Play Now", "العب الآن"), systemImage: "play.circle.fill")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(colors: [.purple, .pink],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .purple.opacity(0.5), radius: 12, y: 6)
            }

            Button { goToLeaderboard = true } label: {
                Label(appState.str("Leaderboard", "المتصدرون"), systemImage: "trophy.fill")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(.white.opacity(0.08))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }

    // MARK: - Language Picker

    private var languagePicker: some View {
        HStack(spacing: 0) {
            ForEach(AppLanguage.allCases, id: \.self) { lang in
                Button {
                    withAnimation(.spring(response: 0.3)) { appState.language = lang }
                } label: {
                    Text(lang.displayName)
                        .font(.subheadline.bold())
                        .foregroundStyle(appState.language == lang ? Color(hex: "#0d0d1f") ?? .black : .white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(appState.language == lang ? .white : .clear)
                        )
                }
            }
        }
        .padding(4)
        .background(Capsule().fill(.white.opacity(0.12)))
    }
}
