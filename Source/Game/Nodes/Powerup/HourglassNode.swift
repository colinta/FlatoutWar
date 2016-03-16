//
//  HourglassNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

let HourglassTimeout: CGFloat = 6
private let SlowdownRate: CGFloat = 0.25

class HourglassNode: Node {
    var slowNodes: [Node] = []
    private var timeout: CGFloat = HourglassTimeout
    private let slowdownMod = Mod(attr: .TimeRate(SlowdownRate))

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

        for node in slowNodes {
            node.removeMod(slowdownMod)
        }

        if let world = world {
            slowNodes = []
            for enemy in world.enemies where enemy.enemyComponent!.targetable {
                if enemy.touches(self) {
                    enemy.addMod(slowdownMod)
                    slowNodes << enemy
                }
            }
        }
    }

}
