//
//  EnemyShrapnelNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class EnemyShrapnelNode: Node {

    required init(type: ImageIdentifier.EnemyType) {
        super.init()
        self << SKSpriteNode(id: .EnemyShrapnel(type: type))
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
