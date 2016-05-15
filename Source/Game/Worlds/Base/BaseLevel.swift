//
//  BaseLevel.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel: Level {

    required init() {
        super.init()
        levelSelect = .Base
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
