////
///  BackgroundAudioNode.swift
//

import AVFoundation


class BackgroundAudioNode: Node {
    indirect enum AudioState {
        case Playing
        case Paused(resume: AudioState)
        case Stopped
    }

    let audioPlayer: AVAudioPlayer?
    var state: AudioState = .Stopped
    var volume: CGFloat = 0
    var deltaVolume: CGFloat = 3.333

    convenience init?(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "caf") else { return nil }
        self.init(url: url)
    }

    init(url: URL) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 0
            audioPlayer.numberOfLoops = 10
            self.audioPlayer = audioPlayer
        }
        catch {
            self.audioPlayer = nil
        }
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ dt: CGFloat) {
        guard let audioPlayer = audioPlayer else { return }

        if let volume = moveValue(CGFloat(audioPlayer.volume), towards: volume, by: dt * deltaVolume) {
            audioPlayer.volume = Float(volume)
        }
    }

    override func reset() {
        super.reset()
        state = .Stopped
        audioPlayer?.stop()
    }

    func play() {
        volume = 1
        state = .Playing
        audioPlayer?.play()
    }

    func pause() {
        switch state {
        case .Playing:
            audioPlayer?.pause()
        default: break
        }

        state = .Paused(resume: state)
    }

    func resume() {
        switch state {
        case let .Paused(nextState):
            state = nextState
        default: break
        }

        switch state {
        case .Playing:
            audioPlayer?.play()
        default: break
        }
    }

}
