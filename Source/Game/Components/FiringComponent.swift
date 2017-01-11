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

    typealias OnFireAngle = (CGFloat) -> Void
    typealias OnFireTarget = (Node) -> Void
    typealias OnFirePosition = (CGPoint) -> Void
    var _onFireAngle: [OnFireAngle] = []
    func onFireAngle(_ handler: @escaping OnFireAngle) { _onFireAngle << handler }
    var _onFireTarget: [OnFireTarget] = []
    func onFireTarget(_ handler: @escaping OnFireTarget) { _onFireTarget << handler }
    var _onFirePosition: [OnFirePosition] = []
    func onFirePosition(_ handler: @escaping OnFirePosition) { _onFirePosition << handler }

    override func reset() {
        super.reset()
        prevTarget = nil
        _onFireAngle = []
        _onFireTarget = []
        _onFirePosition = []
    }

    required override init() {
        super.init()
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
            for handler in _onFireAngle {
                handler(angle)
            }
            lastFiredCooldown = cooldown
        }
        else if let targetingComponent = node.enemyTargetingComponent,
            targetingComponent.enabled,
            let target = targetingComponent.currentTarget,
            let position = targetingComponent.firingPosition()
        {
            for handler in _onFirePosition {
                handler(position)
            }
            for handler in _onFireTarget {
                handler(target)
            }

            let angle = position.angle
            self.angle = angle
            for handler in _onFireAngle {
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
