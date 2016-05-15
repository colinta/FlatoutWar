//
//  TutorialLevel4Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel4Config: BaseConfig {
    override var canUpgrade: Bool { return false }

    override var possibleExperience: Int { return 130 }
    override var requiredExperience: Int { return 115 }
    override var requiredResources: Int { return 30 }

    override func tutorial() -> Tutorial? { return RapidFireTutorial() }
    override func nextLevel() -> BaseLevel {
        return TutorialLevel5()
    }

}
