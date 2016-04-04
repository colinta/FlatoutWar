//
//  BaseLevel2Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2Config: BaseConfig {
    override var canUpgrade: Bool { return false }
    override var availableTurrets: [Turret] { return [] }

    override var possibleExperience: Int { return 120 }
    override func tutorial() -> Tutorial? { return PowerupTutorial() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel3()
    }

}
