////
///  FiringComponent.swift
//

class FiringComponent: Component {
    weak var turret: SKNode?
    var cooldown: CGFloat = 1
    private(set) var angle: CGFloat?
    var lastFired: CGFloat = 0
    var forceFire = false {
        willSet {
            if newValue != forceFire && lastFired <= 0 {
                lastFired = cooldown
            }
        }
    }

    typealias OnFire = (_ angle: CGFloat) -> Void
    var _onFire: [OnFire] = []
    func onFire(_ handler: @escaping OnFire) { _onFire << handler }

    override func reset() {
        super.reset()
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
        guard lastFired <= 0 else {
            lastFired -= dt
            return
        }

        angle = nil
        if forceFire {
            let angle = (turret ?? node).zRotation
            for handler in _onFire {
                handler(angle)
            }
            lastFired = cooldown
        }
        else if let targetingComponent = node.targetingComponent,
            let angle = targetingComponent.angleToCurrentTarget(),
            targetingComponent.enabled
        {
            self.angle = angle
            for handler in _onFire {
                handler(angle)
            }
            lastFired = cooldown
        }
    }
}
