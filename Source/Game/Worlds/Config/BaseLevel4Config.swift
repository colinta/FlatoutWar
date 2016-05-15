//
//  BaseLevel4Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel4Config: BaseConfig {
    override var possibleExperience: Int { return 1000 }
    override var requiredExperience: Int { return 0 }
    override var requiredResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel5()
    }

}
