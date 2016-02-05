//
//  BaseLevel5Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel5Config: BaseConfig {
    override var possibleExperience: Int { return 100 }
    override func nextLevel() -> BaseLevel {
        print("returning BaseLevel5, but SHOULD return BaseLevel6")
        return BaseLevel5() ///////////// <------------- should be 6
    }

}
