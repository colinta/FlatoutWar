//
//  BaseLevel16.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel16: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel16Config() }
    override func goToNextWorld() {
        director?.presentWorld(BaseLevelSelectWorld())
    }

    override func populateWorld() {
        super.populateWorld()
    }

}
