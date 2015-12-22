//
//  BasePlayerNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BasePlayerNode: Node {

    override func populate() {
        let radar = SKSpriteNode(id: .Radar(upgrade: .One))
        radar.anchorPoint = CGPoint(0, 0.5)
        self << radar
        let base = SKSpriteNode(id: .Base(upgrade: .One))
        self << base
        let turret = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
        self << turret
    }

}
