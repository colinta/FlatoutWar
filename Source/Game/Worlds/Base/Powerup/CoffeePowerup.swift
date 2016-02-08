//
//  CoffeePowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class CoffeePowerup: Powerup {
    override var name: String { return "COFFEE" }
    override var weight: Weight { return .Rare }
    override var count: Int { return 2 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Coffee }

    static let CoffeeTimeout: CGFloat = 10

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()

        powerupEnabled = false
        playerNode?.timeRate = 3
        level?.timeline.after(CoffeePowerup.CoffeeTimeout) {
            self.caffeineWithdrawal()
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
