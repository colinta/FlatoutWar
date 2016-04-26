//
//  TutorialLevel4Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel4Config: BaseConfig {
    override var canUpgrade: Bool { return false }

    override var possibleExperience: Int { return 145 }
    override func tutorial() -> Tutorial? { return DroneTutorial() }
    override func nextLevel() -> BaseLevel {
        return TutorialLevel5()
    }

}
