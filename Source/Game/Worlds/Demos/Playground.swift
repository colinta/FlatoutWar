//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: BaseLevel {

    override func loadConfig() -> BaseConfig { return PlaygroundConfig() }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        20.times {
            let enemyNode = EnemySoldierNode()
            enemyNode.name = "soldier"
            // enemyNode.playerTargetingComponent?.enabled = false
            let r: CGFloat = rand(min: 100, max: 400)
            enemyNode.position = CGPoint(r: r, a: rand(min: 0, max: TAU_8))
            // enemyNode.addComponent(WanderingComponent(centeredAround: enemyNode.position))
            self << enemyNode
        }
    }

}


class PlaygroundConfig: BaseConfig {
    override var possibleExperience: Int { return 100 }
    override func nextLevel() -> BaseLevel {
        return Playground()
    }
    override var availablePowerups: [Powerup] { return [
        NetPowerup(),
        MinesPowerup(),
        LaserPowerup(),
    ] }
}
