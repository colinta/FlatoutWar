//
//  World.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class World: Node {
    let timeline = TimelineComponent()

    override func populate() {
        self.addComponent(timeline)
    }
}
