//
//  BulletRecoilExplosionNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BulletRecoilExplosionNode: Node {

    required init() {
        super.init()
        size = CGSize(r: 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func populate() {
        // self << SKSpriteNode(id: .Enemy(type: .Soldier))
    }

}
