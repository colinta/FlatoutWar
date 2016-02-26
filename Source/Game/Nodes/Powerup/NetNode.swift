//
//  NetNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/24/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class NetNode: Node {
    let sprite = SKSpriteNode(id: .Net)

    required init() {
        super.init()
        size = sprite.size
        self << sprite
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
