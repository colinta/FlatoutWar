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
    var prevTarget: Node?
    var targetHealth: Float?
    var forceFire = false {
        willSet {
            if newValue != forceFire && lastFiredCooldown <= 0 {
                lastFiredCooldown = cooldown
            }
        }
    }

    typealias OnFire = (_ angle: CGFloat) -> Void
    var _onFire: [OnFire] = []
    func onFire(_ handler: @escaping OnFire) { _onFire << handler }

    override func reset() {
        super.reset()
        prevTarget = nil
        _onFire = []
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

        angle = nil
        if forceFire {
            let angle = (turret ?? node).zRotation
            for handler in _onFire {
                handler(angle)
            }
            lastFiredCooldown = cooldown
        }
        else if let targetingComponent = node.targetingComponent,
            targetingComponent.enabled,
            let target = targetingComponent.currentTarget,
            let angle = targetingComponent.angleToCurrentTarget()
        {
            self.angle = angle
            for handler in _onFire {
                handler(angle)
            }
            lastFiredCooldown = cooldown

            if targetsPreemptively,
                let health = target.healthComponent?.health,
                let damage = node.firingComponent?.damage
            {
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
