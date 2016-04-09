//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: World {

    override func populateWorld() {
        self << {
            let n = Node()
            n << SKSpriteNode(id: .Warning)
            return n
        }()
    }

    override func update(dt: CGFloat) {
    }

}
