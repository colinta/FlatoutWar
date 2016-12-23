////
///  FiringComponent.swift
//

class FiringComponent: Component {
    weak var turret: SKNode?
    var cooldown: CGFloat = 1
    var damage: Float = 0
    private(set) var angle: CGFloat?
    var lastFiredCooldown: CGFloat = 0
    var targetsPreemptively = false
    var shotsFired = 0
    var prevTarget: Node?
    var targetHealth: Float?
    var forceFire = false {
        willSet {
            if newValue != forceFire && lastFiredCooldown <= 0 {
                lastFiredCooldown = cooldown
            }
        }
    }

    typealias OnFire = (CGFloat) -> Void
    typealias OnFireTarget = (CGPoint) -> Void
    var _onFire: [OnFire] = []
    func onFire(_ handler: @escaping OnFire) { _onFire << handler }
    var _onFireTarget: [OnFireTarget] = []
    func onFireTarget(_ handler: @escaping OnFireTarget) { _onFireTarget << handler }

    override func reset() {
        super.reset()
        prevTarget = nil
        _onFire = []
        _onFireTarget = []
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func update(_ dt: CGFloat) {
        guard lastFiredCooldown <= 0 else {
            lastFiredCooldown -= dt
            return
        }

        self.angle = nil
        if forceFire {
            let angle = (turret ?? node).zRotation
            self.angle = angle
            for handler in _onFire {
                handler(angle)
            }
            lastFiredCooldown = cooldown
        }
        else if let targetingComponent = node.targetingComponent,
            targetingComponent.enabled,
            let target = targetingComponent.currentTarget,
            let position = targetingComponent.firingPosition()
        {
            for handler in _onFireTarget {
                handler(position)
            }

            let angle = position.angle
            self.angle = angle
            for handler in _onFire {
                handler(angle)
            }
            lastFiredCooldown = cooldown

            if targetsPreemptively,
                let health = target.healthComponent?.health,
                let damage = node.firingComponent?.damage
            {
                guard damage > 0 else {
                    fatalError("firingComponent.damage is not set on \(node)")
                }

                if target == prevTarget {
                    targetHealth = min(targetHealth ?? health, health) - damage
                }
                else {
                    targetHealth = health - damage
                }

                if let targetHealth = targetHealth, targetHealth <= 0 {
                    targetingComponent.reacquireAvoidingCurrent()
                }
            }

            prevTarget = target
        }
    }
}
