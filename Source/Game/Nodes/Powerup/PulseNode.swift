//
//  PulseNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

// takes 11 seconds to get to edge of screen (284pt, if width is 568pt),
// regardless of offset
private let MaxTime: CGFloat = 10
private let MaxWidth: CGFloat = 325
private let Damage: Float = 10

class PulseNode: Node {
    class Pulse {
        var time: CGFloat = 0
        private let pulseRate: CGFloat
        private let timeOffset: CGFloat
        private var radius: CGFloat = 0 {
            didSet {
                let path = CGPathCreateMutable()
                CGPathAddEllipseInRect(path, nil, CGPoint.zero.rectWithSize(CGSize(r: radius)))
                node.path = path
            }
        }
        let node = SKShapeNode()

        init(offset: CGFloat) {
            self.timeOffset = offset
            self.pulseRate = MaxWidth / (MaxTime - offset)
            node.strokeColor = UIColor(hex: PowerupRed)
            node.lineWidth = 1
        }

        func update(dt: CGFloat) {
            time += dt
            if time >= timeOffset {
                let myTime = time - timeOffset
                radius = myTime * pulseRate

                if MaxTime - myTime < 2 {
                    node.alpha = interpolate(MaxTime - myTime, from: (2, 0), to: (1, 0))
                }
                else if myTime < 2 {
                    node.alpha = interpolate(myTime, from: (0, 2), to: (0, 1))
                }
            }
            else {
                node.alpha = 0
            }
        }
    }

    var pulses: [Pulse] = [
        Pulse(offset: 0),
        Pulse(offset: 1),
        Pulse(offset: 2.5),
    ]

    required init() {
        super.init()
        size = .zero

        for p in pulses {
            self << p.node
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        for p in pulses {
            p.update(dt)
        }

        if let world = world {
            for enemy in world.enemies where enemy.enemyComponent!.targetable {
                for p in pulses {
                    let innerR = p.radius - 1
                    let outerR = p.radius + 1
                    if self.distanceTo(enemy, within: outerR) && !self.distanceTo(enemy, within: innerR) {
                        enemy.healthComponent?.inflict(Damage * Float(dt))

                        if let jiggleComponent = enemy.jiggleComponent {
                            jiggleComponent.resetTimeout()
                        }
                        else {
                            enemy.addComponent(JiggleComponent())
                        }
                    }
                }
            }
        }
    }

}
