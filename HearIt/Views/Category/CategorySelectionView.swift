import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var categories: [Category] = []
    @State private var isLoading = true
    @State private var selected: Category? = nil

    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ZStack {
            Color(hex: "#0d0d1f")?.ignoresSafeArea() ?? Color.black.ignoresSafeArea()

            if isLoading {
                ProgressView()
                    .tint(.purple)
                    .scaleEffect(1.5)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appState.str(
                            "Guess the sound. Earn the most points.",
                            "خمّن الصوت. اكسب أعلى نقاط."
                        ))
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 4)

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(categories) { cat in
                                CategoryCard(category: cat)
                                    .onTapGesture { selected = cat }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle(appState.str("Choose Category", "اختر الفئة"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(item: $selected) { cat in
            GameView(category: cat)
        }
        .task { await load() }
        .environment(\.layoutDirection, appState.language == .arabic ? .rightToLeft : .leftToRight)
    }

    private func load() async {
        do { categories = try await NetworkService.shared.fetchCategories() }
        catch { categories = Category.mock }
        isLoading = false
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: Category
    @EnvironmentObject var appState: AppState
    @State private var pressed = false

    var body: some View {
        VStack(spacing: 14) {
            Text(category.icon)
                .font(.system(size: 52))

            Text(category.displayName(for: appState.language))
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(appState.str("\(category.totalQuestions) Q's", "\(category.totalQuestions) سؤال"))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [category.color.opacity(0.65), category.color.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(category.color.opacity(0.45), lineWidth: 1)
        )
        .scaleEffect(pressed ? 0.94 : 1)
        .animation(.spring(response: 0.25), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}
