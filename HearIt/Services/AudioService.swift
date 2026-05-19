import AVFoundation
import Combine

enum AudioState: Equatable {
    case idle, loading, playing, paused, finished
    case error(String)
}

final class AudioService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    static let shared = AudioService()

    @Published var state: AudioState = .idle
    @Published var progress: Double = 0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var synthesizer = AVSpeechSynthesizer()

    private override init() {
        super.init()
        synthesizer.delegate = self
        DispatchQueue.global(qos: .userInitiated).async {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

    // MARK: - Public

    func play(urlString: String) {
        if urlString.hasPrefix("bundle://") {
            let name = String(urlString.dropFirst("bundle://".count))
            playBundleFile(name: name)
        } else {
            playRemoteURL(urlString: urlString)
        }
    }

    // Speaks text via TTS — used as fallback when no audio file is available
    func speak(text: String, languageCode: String = "en-US") {
        stop()
        state = .playing
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.05
        synthesizer.speak(utterance)
    }

    func replay() {
        player?.seek(to: .zero)
        player?.play()
        state = .playing
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        if let obs = timeObserver { player?.removeTimeObserver(obs) }
        player?.pause()
        player = nil
        state = .idle
        progress = 0
        cancellables.removeAll()
    }

    // MARK: - Private

    private func playBundleFile(name: String) {
        let extensions = ["mp3", "m4a", "aac", "wav"]
        let url = extensions.compactMap { Bundle.main.url(forResource: name, withExtension: $0) }.first
        guard let url else {
            state = .error("not found: \(name)")
            return
        }
        playURL(url)
    }

    private func playRemoteURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            state = .error("Invalid URL")
            return
        }
        playURL(url)
    }

    private func playURL(_ url: URL) {
        stop()
        state = .loading

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)

        item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    self?.player?.play()
                    self?.state = .playing
                case .failed:
                    self?.state = .error("Failed to load audio")
                default: break
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.state = .finished }
            .store(in: &cancellables)

        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds,
                  duration > 0, duration.isFinite else { return }
            self?.progress = time.seconds / duration
        }
    }

    // MARK: - AVSpeechSynthesizerDelegate

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.state = .finished }
    }
}
