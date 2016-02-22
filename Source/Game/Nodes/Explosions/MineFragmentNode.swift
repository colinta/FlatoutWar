//
//  MineFragmentNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let NumSprites = 5
private let MaxDistance: CGFloat = 30
private let Duration: CGFloat = 0.5

class MineFragmentNode: Node {
    private var sprites: [SKSpriteNode] = []
    private var phase: CGFloat = 0

    required init() {
        super.init()
        size = CGSize(10)

        for _ in 0..<NumSprites {
            let sprite = SKSpriteNode(id: .MineExplosion)
            sprites << sprite
            self << sprite
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        phase += dt / Duration
        guard phase <= 1 else {
            removeFromParent()
            return
        }

        let distance = phase * MaxDistance
        let alpha = min(1, 4 * (1 - phase))

        for (index, sprite) in sprites.enumerate() {
            let a: CGFloat = CGFloat(index) * TAU / CGFloat(sprites.count)
            sprite.position = CGPoint(r: distance, a: a)
            sprite.alpha = alpha
            sprite.zRotation = a
        }
    }

}
