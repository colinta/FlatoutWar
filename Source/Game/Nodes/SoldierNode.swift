//
//  SoldierNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class SoldierNode: Node {

    override func populate() {
        self << SKSpriteNode(id: .Enemy(type: .Soldier))
    }

}
