//
//  BaseLevel1Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel1Config: BaseConfig {
    override var possibleExperience: Int { return 175 }
    override func nextLevel() -> BaseLevel {
        return BaseLevel2()
    }

}
