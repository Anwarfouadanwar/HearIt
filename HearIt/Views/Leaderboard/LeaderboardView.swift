import SwiftUI

struct LeaderboardView: View {
    let categoryId: String?

    @EnvironmentObject var appState: AppState
    @StateObject private var vm = LeaderboardViewModel()
    @State private var categories: [Category] = Category.mock
    @State private var selectedCategoryId: String? = nil

    var body: some View {
        ZStack {
            Color(hex: "#0d0d1f")?.ignoresSafeArea() ?? Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                categoryFilter
                    .padding(.top, 8)

                if vm.isLoading {
                    Spacer()
                    ProgressView().tint(.purple).scaleEffect(1.3)
                    Spacer()
                } else if vm.entries.isEmpty {
                    Spacer()
                    emptyState
                    Spacer()
                } else {
                    leaderboardList
                }
            }
        }
        .navigationTitle(appState.str("Leaderboard", "المتصدرون"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task { await vm.load(categoryId: categoryId ?? selectedCategoryId) }
        .onChange(of: selectedCategoryId) { _, newId in
            Task { await vm.load(categoryId: newId) }
        }
        .environment(\.layoutDirection, appState.language == .arabic ? .rightToLeft : .leftToRight)
    }

    // MARK: - Category Filter Chips

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                chip(idValue: nil, label: appState.str("All", "الكل"))
                ForEach(categories) { cat in
                    chip(idValue: cat.id,
                         label: "\(cat.icon) \(cat.displayName(for: appState.language))")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }

    private func chip(idValue: String?, label: String) -> some View {
        let selected = selectedCategoryId == idValue
        return Button { selectedCategoryId = idValue } label: {
            Text(label)
                .font(.subheadline.bold())
                .foregroundStyle(selected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(selected ? Color.white : Color.white.opacity(0.10))
                )
        }
    }

    // MARK: - List

    private var leaderboardList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(Array(vm.entries.enumerated()), id: \.element.id) { idx, entry in
                    LeaderboardRow(entry: entry, rank: idx + 1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Empty

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "trophy")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.2))
            Text(appState.str("No scores yet. Be the first!", "لا توجد نتائج بعد. كن الأول!"))
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}

// MARK: - Row

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let rank: Int

    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(hex: "#C0C0C0") ?? .gray
        case 3: return Color(hex: "#CD7F32") ?? .orange
        default: return .white.opacity(0.35)
        }
    }

    private var rankIcon: String? {
        switch rank {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return nil
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            // Rank
            ZStack {
                if let icon = rankIcon {
                    Image(systemName: icon)
                        .foregroundStyle(rankColor)
                        .font(.title3)
                } else {
                    Text("#\(rank)")
                        .font(.subheadline.bold())
                        .foregroundStyle(rankColor)
                }
            }
            .frame(width: 32)

            // Avatar placeholder
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 42, height: 42)
                Text(String(entry.playerName.prefix(1)).uppercased())
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            // Name + stats
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.playerName)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("\(entry.questionsAnswered) correct")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.45))
            }

            Spacer()

            Text("\(entry.score)")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(.yellow)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(rank <= 3 ? 0.1 : 0.05)))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(rank <= 3 ? rankColor.opacity(0.4) : Color.clear, lineWidth: 1)
        )
    }
}
