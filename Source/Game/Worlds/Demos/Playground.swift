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
        // timeline.every(0.5, start: .Delayed(), times: 100, block: generateEnemy(0))
    }

}


class PlaygroundConfig: BaseConfig {
    override var possibleExperience: Int { return 100 }
    override func nextLevel() -> BaseLevel {
        return Playground()
    }
    override var availablePowerups: [Powerup] { return [
        BomberPowerup()
    ] }
}
