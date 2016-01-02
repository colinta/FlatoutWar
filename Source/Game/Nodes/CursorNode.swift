//
//  CursorNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/23/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private var dScale: CGFloat = 1.5
private var dAlphaUp: CGFloat = 10
private var dAlphaDown: CGFloat = 4
private var dRotation: CGFloat = 0.7

class CursorNode: Node {
    var selected = false
    private var spriteScale: CGFloat = 0
    private var sprite = SKSpriteNode(id: .Cursor)

    required init() {
        super.init()
        z = .Top
        sprite.alpha = 0
        self << sprite
        size = sprite.size
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selected = coder.decode("selected") ?? false
        spriteScale = coder.decodeCGFloat("spriteScale") ?? 0
        sprite = coder.decode("sprite") ?? sprite
        sprite.setScale(0.5)
        size = sprite.size
        sprite.setScale(spriteScale)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(selected, key: "selected")
        encoder.encode(CGFloat(selected ? 1 : 0), key: "spriteScale")
        encoder.encode(sprite, key: "sprite")
    }

    override func update(dt: CGFloat) {
        let destAlpha: CGFloat
        let destScale: CGFloat
        if selected {
            destAlpha = 1
            destScale = 1
        }
        else {
            destAlpha = 0
            destScale = 0
        }

        if spriteScale < destScale {
            spriteScale = min(spriteScale + dScale * dt, destScale)
        }
        else if spriteScale > destScale {
            spriteScale = max(spriteScale - dScale * dt, destScale)
        }
        self.setScale(easeOutElastic(time: spriteScale))

        let alpha = sprite.alpha
        if alpha < destAlpha {
            sprite.alpha = min(alpha + dAlphaUp * dt, destAlpha)
        }
        else if alpha > destAlpha {
            sprite.alpha = max(alpha - dAlphaDown * dt, destAlpha)
        }

        sprite.zRotation += dRotation * dt
    }

}
