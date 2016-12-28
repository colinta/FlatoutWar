////
///  PulseNode.swift
//

private let MaxWidth: CGFloat = 325
private let Damage: Float = 5

class PulseNode: Node {
    static let MaxTime: CGFloat = 10

    class Pulse {
        var time: CGFloat = 0
        var active = true
        fileprivate let pulseRate: CGFloat
        fileprivate let timeOffset: CGFloat
        fileprivate var radius: CGFloat = 0 {
            didSet {
                let path = CGMutablePath()
                path.addEllipse(in: CGRect(size: CGSize(r: radius)))
                node.path = path
            }
        }
        let node = SKShapeNode()

        init(offset: CGFloat) {
            self.timeOffset = offset
            self.pulseRate = MaxWidth / (PulseNode.MaxTime - offset)
            node.strokeColor = UIColor(hex: PowerupRed)
            node.lineWidth = 1
        }

        func update(_ dt: CGFloat) {
            time += dt
            if time >= timeOffset {
                let myTime = time - timeOffset
                radius = myTime * pulseRate

                if PulseNode.MaxTime - myTime < 0 {
                    node.alpha = 0
                    active = false
                }
                else if PulseNode.MaxTime - myTime < 2 {
                    node.alpha = interpolate(PulseNode.MaxTime - myTime, from: (2, 0), to: (1, 0))
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

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func update(_ dt: CGFloat) {
        for p in pulses {
            p.update(dt)
        }

        guard pulses.any({ $0.active }) else {
            removeFromParent()
            return
        }

        if let world = world {
            for enemy in world.enemies where enemy.enemyComponent!.targetable {
                for p in pulses where p.active {
                    let innerR: CGFloat = max(p.radius - enemy.radius, 0)
                    let outerR: CGFloat = p.radius + enemy.radius
                    if self.distanceTo(enemy, within: outerR) && !self.distanceTo(enemy, within: innerR) {
                        enemy.healthComponent?.inflict(damage: Damage * Float(dt))

                        if let jiggleComponent = enemy.get(component: JiggleComponent.self) {
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
