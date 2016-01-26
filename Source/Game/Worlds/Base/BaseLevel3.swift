//
//  BaseLevel3.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel3: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel3Config() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel4()
    }

    override func populateWorld() {
        super.populateWorld()
    }

}
