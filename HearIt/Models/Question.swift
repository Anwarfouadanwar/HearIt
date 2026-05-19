import Foundation

struct Answer: Codable, Identifiable {
    let id: String
    let textEn: String
    let textAr: String

    func text(for lang: AppLanguage) -> String {
        lang == .arabic ? textAr : textEn
    }
}

struct Question: Codable, Identifiable {
    let id: String
    let audioUrl: String
    let answers: [Answer]   // always 4
    let correctIndex: Int   // 0-3
    let categoryId: String
    let hintEn: String
    let hintAr: String

    var correctAnswer: Answer { answers[correctIndex] }

    func hint(for lang: AppLanguage) -> String {
        lang == .arabic ? hintAr : hintEn
    }

    // MARK: - Mock Data (Arab Singers)

    static let mock: [Question] = [
        Question(
            id: "q1",
            audioUrl: "https://cdn.hearitapp.com/audio/fairouz_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Fairouz",     textAr: "فيروز"),
                Answer(id: "a2", textEn: "Warda",       textAr: "وردة"),
                Answer(id: "a3", textEn: "Umm Kulthum", textAr: "أم كلثوم"),
                Answer(id: "a4", textEn: "Sabah",       textAr: "صباح"),
            ],
            correctIndex: 0, categoryId: "arab-singers",
            hintEn: "Lebanese icon", hintAr: "أيقونة لبنانية"
        ),
        Question(
            id: "q2",
            audioUrl: "https://cdn.hearitapp.com/audio/umm_kulthum_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Fairouz",     textAr: "فيروز"),
                Answer(id: "a2", textEn: "Warda",       textAr: "وردة"),
                Answer(id: "a3", textEn: "Umm Kulthum", textAr: "أم كلثوم"),
                Answer(id: "a4", textEn: "Sabah",       textAr: "صباح"),
            ],
            correctIndex: 2, categoryId: "arab-singers",
            hintEn: "Egyptian legend", hintAr: "أسطورة مصرية"
        ),
        Question(
            id: "q3",
            audioUrl: "https://cdn.hearitapp.com/audio/abdel_halim_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Abdel Halim Hafez", textAr: "عبد الحليم حافظ"),
                Answer(id: "a2", textEn: "Mohamed Mounir",   textAr: "محمد منير"),
                Answer(id: "a3", textEn: "Amr Diab",         textAr: "عمرو دياب"),
                Answer(id: "a4", textEn: "Kadhem Al Saher",  textAr: "كاظم الساهر"),
            ],
            correctIndex: 0, categoryId: "arab-singers",
            hintEn: "The dark nightingale", hintAr: "العندليب الأسمر"
        ),
        Question(
            id: "q4",
            audioUrl: "https://cdn.hearitapp.com/audio/amr_diab_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Tamer Hosny",  textAr: "تامر حسني"),
                Answer(id: "a2", textEn: "Amr Diab",    textAr: "عمرو دياب"),
                Answer(id: "a3", textEn: "Mohamed Fo'ad", textAr: "محمد فؤاد"),
                Answer(id: "a4", textEn: "Hani Shaker",  textAr: "هاني شاكر"),
            ],
            correctIndex: 1, categoryId: "arab-singers",
            hintEn: "Habibi ya nour el ain", hintAr: "حبيبي يا نور العين"
        ),
        Question(
            id: "q5",
            audioUrl: "https://cdn.hearitapp.com/audio/kadhem_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Kadhem Al Saher",  textAr: "كاظم الساهر"),
                Answer(id: "a2", textEn: "Ilham Al Madfai",  textAr: "إلهام المدفعي"),
                Answer(id: "a3", textEn: "Majid Al Mohandis", textAr: "ماجد المهندس"),
                Answer(id: "a4", textEn: "Saber Al Rebai",   textAr: "صابر الرباعي"),
            ],
            correctIndex: 0, categoryId: "arab-singers",
            hintEn: "Iraqi romantic singer", hintAr: "المطرب العراقي الرومانسي"
        ),
        Question(
            id: "q6",
            audioUrl: "https://cdn.hearitapp.com/audio/majid_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Rashed Al Majid",  textAr: "راشد الماجد"),
                Answer(id: "a2", textEn: "Ahlam",            textAr: "أحلام"),
                Answer(id: "a3", textEn: "Majid Al Mohandis", textAr: "ماجد المهندس"),
                Answer(id: "a4", textEn: "Nawal Al Kuwaitia", textAr: "نوال الكويتية"),
            ],
            correctIndex: 2, categoryId: "arab-singers",
            hintEn: "Gulf superstar", hintAr: "نجم خليجي"
        ),
        Question(
            id: "q7",
            audioUrl: "https://cdn.hearitapp.com/audio/warda_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Najwa Karam",  textAr: "نجوى كرم"),
                Answer(id: "a2", textEn: "Warda",        textAr: "وردة"),
                Answer(id: "a3", textEn: "Latifa",       textAr: "لطيفة"),
                Answer(id: "a4", textEn: "Angham",       textAr: "أنغام"),
            ],
            correctIndex: 1, categoryId: "arab-singers",
            hintEn: "Algerian-Egyptian diva", hintAr: "ديفا جزائرية مصرية"
        ),
        Question(
            id: "q8",
            audioUrl: "https://cdn.hearitapp.com/audio/najwa_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Elissa",      textAr: "إليسا"),
                Answer(id: "a2", textEn: "Najwa Karam", textAr: "نجوى كرم"),
                Answer(id: "a3", textEn: "Carole Samaha", textAr: "كارول سماحة"),
                Answer(id: "a4", textEn: "Haifa Wehbe",  textAr: "هيفاء وهبي"),
            ],
            correctIndex: 1, categoryId: "arab-singers",
            hintEn: "Lebanese mountain voice", hintAr: "صوت الجبل اللبناني"
        ),
        Question(
            id: "q9",
            audioUrl: "https://cdn.hearitapp.com/audio/mounir_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Mohamed Mounir", textAr: "محمد منير"),
                Answer(id: "a2", textEn: "Hamid Al Shaeri", textAr: "حميد الشاعري"),
                Answer(id: "a3", textEn: "Mustafa Amar",   textAr: "مصطفى قمر"),
                Answer(id: "a4", textEn: "Hisham Abbas",   textAr: "هشام عباس"),
            ],
            correctIndex: 0, categoryId: "arab-singers",
            hintEn: "King of music", hintAr: "ملك"
        ),
        Question(
            id: "q10",
            audioUrl: "https://cdn.hearitapp.com/audio/elissa_01.mp3",
            answers: [
                Answer(id: "a1", textEn: "Nancy Ajram",  textAr: "نانسي عجرم"),
                Answer(id: "a2", textEn: "Elissa",       textAr: "إليسا"),
                Answer(id: "a3", textEn: "Carole Samaha", textAr: "كارول سماحة"),
                Answer(id: "a4", textEn: "Myriam Fares",  textAr: "ميريام فارس"),
            ],
            correctIndex: 1, categoryId: "arab-singers",
            hintEn: "Lebanese pop queen", hintAr: "ملكة البوب اللبنانية"
        ),
    ]
}
