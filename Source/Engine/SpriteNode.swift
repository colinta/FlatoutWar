//
//  SpriteNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/17/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class SpriteNode: Node {
    let sprite = SKSpriteNode()

    required init(id: ImageIdentifier) {
        super.init()
        sprite.textureId(id)
        size = sprite.size
    }

    required convenience init() {
        self.init(id: .None)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
