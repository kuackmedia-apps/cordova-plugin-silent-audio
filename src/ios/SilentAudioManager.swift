import Foundation
import AVFoundation

@objc class SilentAudioManager: NSObject {
    static let shared = SilentAudioManager()
    private var player: AVAudioPlayer?

    @objc func start() {
        guard let url = Bundle.main.url(forResource: "silent", withExtension: "mp3") else {
            print("silent.mp3 not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.0
            player?.numberOfLoops = -1
            player?.prepareToPlay()
            player?.play()

            print("Silent audio started")
        } catch {
            print("Error starting silent audio: \(error)")
        }
    }

    @objc func pause() {
        player?.pause()
        print("Silent audio paused")
    }

    @objc func stop() {
        player?.stop()
        player = nil

        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Error stopping AVAudioSession: \(error)")
        }

        print("Silent audio stopped")
    }
}
