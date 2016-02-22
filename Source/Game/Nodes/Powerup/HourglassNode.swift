//
//  HourglassNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

let HourglassTimeout: CGFloat = 6

class HourglassNode: Node {
    var slowNodes: [(Node, CGFloat)] = []
    private let slowdownRate: CGFloat = 0.25
    private var timeout: CGFloat = HourglassTimeout

    private let sprite = SKSpriteNode(id: .HourglassZone)
    private let slowdownSprite = SKSpriteNode(id: .HourglassZone)

    private let growOutComponent = PhaseComponent()
    private let growInComponent = PhaseComponent()

    required init() {
        super.init()
        size = CGSize(HourglassSize)

        self << sprite
        self << slowdownSprite

        growOutComponent.duration = 1
        growOutComponent.easing = .EaseOutCubic
        addComponent(growOutComponent)

        growInComponent.loops = true
        growInComponent.duration = 2
        growInComponent.easing = .EaseOutExpo
        growInComponent.startValue = slowdownSprite.xScale
        growInComponent.finalValue = 0
        addComponent(growInComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        slowdownSprite.setScale(growInComponent.value)

        if timeout > 0 {
            setScale(growOutComponent.phase)

            timeout -= dt
            if timeout <= 0 {
                growOutComponent.removeFromNode()

                let scaleTo = self.scaleTo(0, duration: HourglassTimeout)
                scaleTo.onScaled {
                    self.removeFromParent()
                }
            }
        }

        for (node, speed) in slowNodes {
            node.timeRate = speed
        }

        if let world = world {
            slowNodes = []
            for enemy in world.enemies {
                if enemy.touches(self) {
                    slowNodes << (enemy, enemy.timeRate)
                    enemy.timeRate = slowdownRate
                }
            }
        }
    }

}
