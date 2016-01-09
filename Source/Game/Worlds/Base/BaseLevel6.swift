//
//  BaseLevel6.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel6: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel6Config() }
    override func tutorial() -> Tutorial { return DroneTutorial() }

    override func populateWorld() {
        super.populateWorld()
    }

    override func nextLevel() -> BaseLevel {
        return BaseLevel7()
    }

}
