//
//  PercentBar.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PercentBar: Node {
    let sprite = SKSpriteNode()
    let minSprite = SKSpriteNode()

    var style: PercentStyle = .Default { didSet { updateSprite() } }
    var complete: CGFloat = 0 { didSet {
        updateSprite()
    } }
    var minimum: CGFloat? { didSet {
        updateSprite()
    } }

    private func updateSprite() {
        sprite.textureId(.Percent(Int(round(min(max(complete, 0), 1) * 100)), style: style))
        size = sprite.size

        if let minimum = minimum {
            let x = size.width * (min(max(minimum, 0), 1) - 0.5)
            minSprite.position.x = x
            minSprite.textureId(.ColorLine(length: size.height * 2, color: style.color))
        }
        else {
            minSprite.textureId(.None)
        }
    }

    required init() {
        super.init()
        self << sprite
        self << minSprite
        minSprite.zRotation = TAU_4

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
