//
//  ShieldNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let Damage: Float = 10

class ShieldNode: Node {
    private let sprite = SKSpriteNode(id: .Shield(phase: 0))
    let segments: [ShieldSegmentNode] = [
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
        ShieldSegmentNode(),
    ]
    private var phase = 0
    private var outerShieldRadius: CGFloat = 60
    private var innerShieldRadius: CGFloat = 57

    required init() {
        super.init()
        size = CGSize(120)

        let arc = TAU / CGFloat(segments.count)
        var angle: CGFloat = 0
        for segment in segments {
            segment.position = CGPoint(r: 58.5, a: angle)
            segment.zRotation = angle
            angle += arc
            self << segment
        }
        sprite.zPosition = Z.Below.rawValue
        self << sprite
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        phase = (phase + 1) % 100
        sprite.textureId(.Shield(phase: phase))

        var damage: Float = 0
        var totalDamage: Float = 0
        for segment in segments {
            damage += segment.damage
            totalDamage += segment.initialDamage
        }

        guard damage > 0 else {
            removeFromParent()
            return
        }

        sprite.alpha = CGFloat(damage / totalDamage)

        if let world = world {
            for enemy in world.enemies where enemy.enemyComponent!.targetable {
                if distanceTo(enemy, within: outerShieldRadius + enemy.radius) && !distanceTo(enemy, within: innerShieldRadius - enemy.radius) {
                    let deltaAngle: CGFloat = TAU / CGFloat(segments.count)
                    let enemyAngle = normalizeAngle(angleTo(enemy) + deltaAngle / 2)
                    var angle: CGFloat = 0
                    for segment in segments {
                        angle += deltaAngle
                        if enemyAngle < angle || segment == segments.last {
                            let enemyHealth = enemy.healthComponent?.health ?? 0
                            if segment.damage > 0 && enemyHealth > 0 {
                                let damage: Float
                                if segment.damage < enemyHealth {
                                    damage = segment.damage
                                    segment.damage = 0
                                    segment.fadeTo(0, duration: 0.3, removeNode: true)
                                }
                                else {
                                    damage = enemyHealth
                                    segment.damage -= enemyHealth
                                    segment.fadeTo(CGFloat(segment.damage / segment.initialDamage), duration: 0.1)
                                }
                                enemy.healthComponent?.inflict(damage)
                            }
                            break
                        }
                    }
                }
            }
        }
    }

}


class ShieldSegmentNode: Node {
    private let sprite = SKSpriteNode(id: .ShieldSegment(health: 100))
    var initialDamage: Float = 6
    var damage: Float

    required init() {
        self.damage = initialDamage
        super.init()
        size = sprite.size
        sprite.zPosition = Z.Below.rawValue
        shape = .Rect
        self << sprite
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
