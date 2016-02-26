//
//  NetPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/24/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NetPowerup: Powerup {
    override var name: String { return "NET" }
    override var count: Int { return 5 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Net }

    required override init() {
        super.init()
    }

    override func activate(level: BaseLevel) {
        super.activate(level)

        self.onNextTap(slowmo: true) { position in
            let node = NetNode(at: position)
            node.scaleTo(1, start: 0, duration: 0.8, easing: .EaseOutElastic)
            level << node

            level.timeline.after(1) {
                node.fadeTo(0, duration: 1, removeNode: true)
            }
        }
    }

}
