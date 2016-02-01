//
//  BaseLevel1Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel1Config: BaseConfig {
    override var canUpgrade: Bool { return false }
    override var canPowerup: Bool { return false }

    override var possibleExperience: Int { return 110 }
    override func tutorial() -> Tutorial? { return AutoFireTutorial() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel2()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
