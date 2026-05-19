import AVFoundation
import Combine

enum AudioState: Equatable {
    case idle, loading, playing, paused, finished
    case error(String)
}

final class AudioService: ObservableObject {
    static let shared = AudioService()

    @Published var state: AudioState = .idle
    @Published var progress: Double = 0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        // Run off the main thread — setActive can briefly block UI if called inline
        DispatchQueue.global(qos: .userInitiated).async {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

    func play(urlString: String) {
        guard let url = URL(string: urlString) else {
            state = .error("Invalid URL")
            return
        }
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

    func replay() {
        player?.seek(to: .zero)
        player?.play()
        state = .playing
    }

    func stop() {
        if let obs = timeObserver { player?.removeTimeObserver(obs) }
        player?.pause()
        player = nil
        state = .idle
        progress = 0
        cancellables.removeAll()
    }
}
