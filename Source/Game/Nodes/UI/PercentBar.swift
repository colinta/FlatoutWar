//
//  PercentBar.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PercentBar: Node {
    let sprite = SKSpriteNode()
    var style: PercentStyle = .Default { didSet { updateSprite() } }
    var complete: CGFloat = 0 { didSet {
        updateSprite()
    } }

    private func updateSprite() {
        sprite.textureId(.Percent(Int(round(min(max(complete, 0), 1) * 100)), style: style))
        size = sprite.size
    }

    required init() {
        super.init()
        self << sprite
        updateSprite()
        self.size = sprite.size
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
