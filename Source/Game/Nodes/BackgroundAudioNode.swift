//
//  BackgroundAudioNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 6/27/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

import AVFoundation


class BackgroundAudioNode: Node {
    let audioPlayer: AVAudioPlayer?
    var volume: CGFloat = 0
    var deltaVolume: CGFloat = 3.333

    init(url: NSURL) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOfURL: url)
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

    override func update(dt: CGFloat) {
        guard let audioPlayer = audioPlayer else { return }

        if let volume = moveValue(CGFloat(audioPlayer.volume), towards: volume, by: dt * deltaVolume) {
            audioPlayer.volume = Float(volume)
        }
    }

    override func reset() {
        super.reset()
        audioPlayer?.stop()
    }

    func play() {
        volume = 1
        audioPlayer?.play()
    }

}
