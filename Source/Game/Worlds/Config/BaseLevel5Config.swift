//
//  BaseLevel5Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/25/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel5Config: BaseConfig {
    override var possibleExperience: Int { return 2 }
    override var requiredExperience: Int { return 0 }
    override var requiredResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }
}
