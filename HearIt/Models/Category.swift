import SwiftUI

struct Category: Codable, Identifiable, Hashable {
    let id: String
    let nameEn: String
    let nameAr: String
    let icon: String
    let colorHex: String
    let totalQuestions: Int

    var color: Color { Color(hex: colorHex) ?? .purple }

    func displayName(for lang: AppLanguage) -> String {
        lang == .arabic ? nameAr : nameEn
    }

    static let mock: [Category] = [
        Category(id: "arab-singers",  nameEn: "Arab Singers",       nameAr: "مطربون عرب",      icon: "🎤", colorHex: "#E91E63", totalQuestions: 50),
        Category(id: "animals",       nameEn: "Animals",            nameAr: "حيوانات",          icon: "🦁", colorHex: "#4CAF50", totalQuestions: 40),
        Category(id: "instruments",   nameEn: "Music Instruments",  nameAr: "آلات موسيقية",    icon: "🎸", colorHex: "#9C27B0", totalQuestions: 35),
        Category(id: "car-engines",   nameEn: "Car Engines",        nameAr: "محركات السيارات", icon: "🚗", colorHex: "#FF5722", totalQuestions: 30),
        Category(id: "languages",     nameEn: "Languages",          nameAr: "لغات",             icon: "🌍", colorHex: "#2196F3", totalQuestions: 25),
        Category(id: "nature",        nameEn: "Nature Sounds",      nameAr: "أصوات الطبيعة",  icon: "🌿", colorHex: "#009688", totalQuestions: 45),
        Category(id: "sports",        nameEn: "Sports",             nameAr: "رياضة",            icon: "⚽", colorHex: "#FF9800", totalQuestions: 28),
        Category(id: "intl-singers",  nameEn: "World Singers",      nameAr: "مطربون عالميون",  icon: "🌟", colorHex: "#607D8B", totalQuestions: 40),
    ]
}
