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
    │   └── AudioService.swift        AVPlayer wrapper for streaming
    └── Utilities/
        └── Extensions.swift         Color(hex:), clockString, cardStyle
```

---

## Xcode Setup

1. Open Xcode → **File > New > Project** → iOS App
2. Set **Product Name** to `HearIt`, interface `SwiftUI`, language `Swift`
3. Delete the generated `ContentView.swift`
4. In Finder, drag all folders from `HearIt/HearIt/` into the Xcode project navigator (check **"Copy items if needed"** and **"Create groups"**)
5. Select the project target → **Signing & Capabilities** → set your Team
6. Build & Run on an iPhone simulator (iOS 17+)

---

## Connecting a Real Backend

Edit `NetworkService.swift`:

```swift
private let baseURL = "https://your-api.hearitapp.com/v1"
var useMockData = false   // ← flip this
```

### Expected API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/categories` | Returns `[Category]` |
| GET | `/questions?categoryId=&count=` | Returns `[Question]` |
| GET | `/leaderboard?categoryId=&limit=` | Returns `[LeaderboardEntry]` |
| POST | `/scores` | Accepts `ScoreSubmission`, returns `ScoreResponse` |

See the model files for full JSON shapes.

---

## Scoring

- Each question = 30 seconds on the clock
- **Points earned = seconds remaining** when the correct answer is tapped
- Max possible = 30 pts × 10 questions = **300 points per round**
- Wrong answer or time expired = 0 points

---

## Adding Real Audio

Replace `audioUrl` in `Question.mock` (or your backend) with actual MP3/AAC URLs.
`AudioService` streams them via `AVPlayer` — any HTTPS URL works.

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
