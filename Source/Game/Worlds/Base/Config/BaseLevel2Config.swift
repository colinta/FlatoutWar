//
//  BaseLevel2Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2Config: BaseConfig {
    override var possibleExperience: Int { return 150 }
    override func nextLevel() -> BaseLevel {
        return BaseLevel3()
    }

}
