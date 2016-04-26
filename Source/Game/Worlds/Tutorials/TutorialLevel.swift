//
//  TutorialLevel.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/25/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class TutorialLevel: BaseLevel {

    required init() {
        super.init()
        levelSelect = .Tutorial
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
