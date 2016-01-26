//
//  BaseLevel2.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel2: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel2Config() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel3()
    }

    override func populateWorld() {
        super.populateWorld()
    }

}
