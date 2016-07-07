//
//  BaseLevel2Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2Config: BaseConfig {
    override var possibleExperience: Int { return 150 }
    // override var requiredExperience: Int { return 0 }
    override var expectedResources: Int { return 0 }

    override func nextLevel() -> Level {
        return BaseLevel3()
    }

}
