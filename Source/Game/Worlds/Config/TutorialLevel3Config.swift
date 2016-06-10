//
//  TutorialLevel3Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel3Config: BaseConfig {
    override var canUpgrade: Bool { return false }
    override var availableTurrets: [Turret] { return [] }

    override var possibleExperience: Int { return 125 }
    override var requiredExperience: Int { return 100 }
    override var requiredResources: Int { return 20 }

    override func tutorial() -> Tutorial? { return PowerupTutorial() }
    override func nextLevel() -> Level {
        return TutorialLevel4()
    }

}
