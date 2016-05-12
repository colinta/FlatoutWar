//
//  TutorialLevel6Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel6Config: BaseConfig {
    override var canUpgrade: Bool { return false }

    override var possibleExperience: Int { return 180 }
    override func nextLevel() -> BaseLevel {
        return BaseLevel1()
    }

}
