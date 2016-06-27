//
//  GameAudioNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 6/27/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

import AVFoundation


class GameAudioNode: Node {
    let audioPlayer: AVAudioPlayer?
    var volume: Float {
        get { return audioPlayer?.volume ?? 0 }
        set { audioPlayer?.volume = newValue }
    }

    convenience init?(name: String) {
        guard let url = NSBundle.mainBundle().URLForResource(name, withExtension: "caf") else { return nil }
        self.init(url: url)
    }

    init(url: NSURL) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1
            self.audioPlayer = audioPlayer
        }
        catch {
            self.audioPlayer = nil
        }
        super.init()

        audioPlayer?.delegate = self
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reset() {
        super.reset()
        audioPlayer?.stop()
    }

    func play() {
        audioPlayer?.play()
    }

}

extension GameAudioNode: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        guard world != nil else { return }
        removeFromParent()
    }
}
