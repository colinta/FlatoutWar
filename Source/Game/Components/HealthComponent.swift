////
///  HealthComponent.swift
//

class HealthComponent: Component {
    typealias OnKilled = Block
    typealias OnHurt = ((damage: Float)) -> Void
    private var _onKilled: [OnKilled] = []
    func onKilled(_ handler: @escaping OnKilled) { _onKilled << handler }

    private var _onHurt: [OnHurt] = []
    func onHurt(_ handler: @escaping OnHurt) { _onHurt << handler }

    var startingHealth: Float {
        didSet {
            health = startingHealth
            died = false
        }
    }
    var healthPercent: Float { return max(min(health / startingHealth, 1), 0) }
    var healthInt: Int { return Int(healthPercent * 100) }
    private(set) var died = false
    private(set) var health: Float

    override func reset() {
        super.reset()
        _onKilled = []
        _onHurt = []
    }

    init(health: Float) {
        startingHealth = health
        self.health = health
        super.init()
    }

    required override init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        startingHealth = coder.decodeFloat(key: "startingHealth") ?? 0
        health = coder.decodeFloat(key: "health") ?? 0
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
        encoder.encode(startingHealth, forKey: "startingHealth")
        encoder.encode(health, forKey: "health")
    }

    func restore(health damage: Float) {
        inflict(damage: -damage)
    }

    func inflict(damage: Float) {
        health = max(min(health - damage, startingHealth), 0)

        let callOnKilled = health <= 0 && !died
        died = health <= 0

        for handler in _onHurt {
            handler(damage)
        }
        if callOnKilled {
            for handler in _onKilled {
                handler()
            }
        }
    }

}
