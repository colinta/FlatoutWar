//
//  BaseLevel15.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel15: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel15Config() }
    override func nextLevel() -> BaseLevel {
        return BaseLevel16()
    }

    override func populateWorld() {
        super.populateWorld()
    }

}
