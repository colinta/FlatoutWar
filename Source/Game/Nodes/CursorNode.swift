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
    var selected: Bool {
        didSet {
            if selected {
                destAlpha = 1
                destScale = 1
                destScalePhase = xScale
            }
            else {
                destAlpha = 0
                destScale = 0
                destScalePhase = xScale
            }
        }
    }
    private var destAlpha: CGFloat?
    private var destScale: CGFloat?
    private var destScalePhase: CGFloat?
    private var sprite = SKSpriteNode(id: .Cursor)

    required init() {
        selected = false
        super.init()
        z = .Top
        alpha = 0
        setScale(0)
        self << sprite
    }

    required init?(coder: NSCoder) {
        selected = coder.decode("selected") ?? false
        super.init(coder: coder)
        sprite = coder.decode("sprite") ?? sprite
        destAlpha = coder.decodeCGFloat("destAlpha")
        destScale = coder.decodeCGFloat("destScale")
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(selected, key: "selected")
        encoder.encode(sprite, key: "sprite")
        if let destAlpha = destAlpha {
            encoder.encode(destAlpha, key: "destAlpha")
        }
        if let destScale = destScale {
            encoder.encode(destScale, key: "destScale")
        }
    }

    override func update(dt: CGFloat) {
        guard xScale > 0 || destScale != nil else {
            return
        }
        sprite.zRotation += dRotation * dt

        if let destScale = destScale, destScalePhase = destScalePhase {
            if let currentScale = moveValue(destScalePhase, towards: destScale, by: dScale * dt) {
                let spriteScale = easeOutElastic(time: currentScale)
                setScale(spriteScale)
                size = sprite.size
                self.destScalePhase = currentScale
            }
            else {
                self.destScale = nil
                self.destScalePhase = nil
            }
        }

        if let destAlpha = destAlpha {
            if let currentAlpha = moveValue(alpha, towards: destAlpha, by: (up: dAlphaUp * dt, down: dAlphaDown * dt)) {
                alpha = currentAlpha
            }
            else {
                self.destAlpha = nil
            }
        }
    }

}
