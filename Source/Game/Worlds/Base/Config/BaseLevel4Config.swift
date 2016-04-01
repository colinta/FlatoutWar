//
//  BaseLevel4Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel4Config: BaseConfig {
    override var canUpgrade: Bool { return false }
    override var availablePowerups: [Powerup] { return [
            GrenadePowerup(),
            LaserPowerup(),
            MinesPowerup(),
        ] }
    override var availableTurrets: [Turret] { return [
        SimpleTurret(),
        RapidTurret(),
    ] }

    override var possibleExperience: Int { return 175 }
    override func nextLevel() -> BaseLevel {
        return BaseLevel5()
    }

}
