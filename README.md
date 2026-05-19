# HearIt 🎤

A bilingual (Arabic/English) voice quiz iOS app. Listen to an audio clip, pick the right answer from 4 choices — race the 30-second clock and earn points equal to the time remaining.

---

## Project Structure

```
HearIt/
└── HearIt/
    ├── App/
    │   ├── HearItApp.swift          Entry point, injects AppState
    │   └── AppState.swift           Language selection, player name
    ├── Models/
    │   ├── Category.swift           Quiz category model + mock data
    │   ├── Question.swift           Question + Answer models + mock data
    │   └── LeaderboardEntry.swift   Score / leaderboard models
    ├── ViewModels/
    │   ├── GameViewModel.swift      Core game logic: timer, scoring, audio
    │   └── LeaderboardViewModel.swift  Fetches & exposes leaderboard
    ├── Views/
    │   ├── Home/HomeView.swift              Landing screen
    │   ├── Category/CategorySelectionView   Category grid
    │   ├── Game/
    │   │   ├── GameView.swift         Main game screen
    │   │   ├── TimerRing.swift        Circular countdown animation
    │   │   └── AnswerButton.swift     Answer choice button with states
    │   ├── Results/RoundResultView    Score summary after a round
    │   └── Leaderboard/LeaderboardView  Global rankings
    ├── Services/
    │   ├── NetworkService.swift      API calls (mock-ready)
    │   └── AudioService.swift        AVPlayer + TTS fallback
    ├── Audio/                        Local MP3s for dev/testing
    └── Utilities/
        └── Extensions.swift         Color(hex:), clockString, cardStyle
```

---

## Xcode Setup

1. Clone the repo and open `HearIt.xcodeproj`
2. Select the project target → **Signing & Capabilities** → set your Team
3. Build & Run on a physical iPhone (iOS 17+)

> Audio files in `HearIt/Audio/` are placeholder tones for local testing.
> Replace them with real clips or connect the backend to hear real audio.

---

## Scoring

- Each question = 30 seconds on the clock
- **Points earned = seconds remaining** when the correct answer is tapped
- Max possible = 30 pts × 10 questions = **300 points per round**
- Wrong answer or time expired = 0 points

---

## Categories (default)

| ID | EN | AR |
|----|----|----|
| `arab-singers` | Arab Singers | مطربون عرب |
| `animals` | Animals | حيوانات |
| `instruments` | Music Instruments | آلات موسيقية |
| `car-engines` | Car Engines | محركات السيارات |
| `languages` | Languages | لغات |
| `nature` | Nature Sounds | أصوات الطبيعة |
| `sports` | Sports | رياضة |
| `intl-singers` | World Singers | مطربون عالميون |

---

## Production Roadmap

### Backend

- [ ] Set up API server (Node/Express or Supabase)
- [ ] `GET /categories` — returns all categories
- [ ] `GET /questions?categoryId=&count=` — returns shuffled questions with audio URLs
- [ ] `POST /scores` — accepts score submission, returns rank
- [ ] `GET /leaderboard?categoryId=&limit=` — returns top scores
- [ ] Audio files hosted on a CDN (Supabase Storage / Cloudflare R2 / S3)
- [ ] Flip `NetworkService.useMockData = false` and update `baseURL`

### Content

- [ ] Record or license real audio clips for Arab Singers (10 clips)
- [ ] Add clips for remaining 7 categories (animals, instruments, car engines, languages, nature, sports, world singers)
- [ ] Arabic TTS or voice-over for category intros (optional)

### App Polish

- [ ] App icon (all required sizes)
- [ ] Launch screen / splash
- [ ] Onboarding screen — enter player name before first game
- [ ] Leaderboard screen wired to real backend data
- [ ] Push notifications — "New category available!", daily challenge
- [ ] Haptic patterns for correct/wrong answers (already partial)
- [ ] Sound effects for UI interactions (button taps, round complete)
- [ ] Streak / combo multiplier mechanic (bonus points for consecutive correct answers)

### App Store

- [ ] Bundle ID confirmed: `com.hearit.app`
- [ ] Provisioning profile + distribution certificate
- [ ] App Store Connect listing (name, description, keywords in AR + EN)
- [ ] Screenshots in Arabic and English (6.5" and 5.5")
- [ ] Privacy policy URL (required for App Store)
- [ ] Age rating questionnaire

---

## Connecting the Backend

Edit `NetworkService.swift`:

```swift
private let baseURL = "https://your-api.hearitapp.com/v1"
var useMockData = false   // ← flip this
```

### Expected API Shapes

**GET /categories** → `[Category]`
```json
[{ "id": "arab-singers", "nameEn": "Arab Singers", "nameAr": "مطربون عرب", "icon": "🎤", "color": "#9B59B6", "totalQuestions": 10 }]
```

**GET /questions?categoryId=arab-singers&count=10** → `[Question]`
```json
[{ "id": "q1", "audioUrl": "https://cdn.hearitapp.com/audio/fairouz_01.mp3", "answers": [...], "correctIndex": 0, "categoryId": "arab-singers", "hintEn": "Lebanese icon", "hintAr": "أيقونة لبنانية" }]
```

**POST /scores** body: `{ "playerName", "categoryId", "score", "questionsAnswered" }`

**GET /leaderboard?categoryId=arab-singers&limit=20** → `[LeaderboardEntry]`
