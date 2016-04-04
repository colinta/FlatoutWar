//
//  CoffeePowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class CoffeePowerup: Powerup {
    override var name: String { return "COFFEE" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Coffee }

    static let CoffeeTimeout: CGFloat = 10

    required override init() {
        super.init()
        self.count = 2
        self.timeout = 20
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        powerupEnabled = false
        playerNode.timeRate = 3
        level.timeline.after(CoffeePowerup.CoffeeTimeout) {
            self.caffeineWithdrawal()
            completion()
        }
    }

    override func levelCompleted(success success: Bool) {
        super.levelCompleted(success: success)
        caffeineWithdrawal()
    }

    func caffeineWithdrawal() {
        playerNode?.timeRate = 1
        powerupEnabled = true
    }

}
