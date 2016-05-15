//
//  TutorialLevel1Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel1Config: BaseConfig {
    override var canUpgrade: Bool { return false }
    override var canPowerup: Bool { return false }
    override var trackResources: Bool { return false }
    override var availableTurrets: [Turret] { return [] }

    override var possibleExperience: Int { return 100 }
    override var requiredExperience: Int { return 90 }

    override func tutorial() -> Tutorial? { return AutoFireTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel2()
    }

    override var storedPlayers: [Node] {
        get { return [BasePlayerNode()] }
        set { }
    }

}
