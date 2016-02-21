//
//  GrenadePowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/15/16.
//  Copyright © 2016 colinta. All rights reserved.
//

class GrenadePowerup: Powerup {
    override var name: String { return "GRENADES" }
    override var count: Int { return 4 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Grenade }

    required override init() {
        super.init()
    }

    override func activate(level: BaseLevel) {
        super.activate(level)

        self.onNextTap(slowmo: true) { position in
            let grenade = GrenadePowerupNode(at: level.playerNode.position)
            let arcToComponent = grenade.arcTo(position, duration: 1)
            arcToComponent.onArrived {
                let bomb = BombNode(maxRadius: 40)
                bomb.position = position
                level << bomb
            }
            arcToComponent.removeNodeOnArrived()
            grenade.alpha = 0
            grenade.fadeTo(1, duration: 1)

            level << grenade
        }
    }

}
