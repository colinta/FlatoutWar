////
///  PlayerComponent.swift
//

class PlayerComponent: Component {
    enum Rammed {
        case damaged
        case attacks
    }

    var intersectable: Bool = true
    private var _targetable: Bool = true
    var targetable: Bool {
        get { return node.active && _targetable }
        set { _targetable = newValue }
    }
    var rammedBehavior: Rammed = .damaged
    weak var intersectionNode: SKNode?

    required override init() {
        super.init()
    }

    override func reset() {
        super.reset()
    }

    override func update(_ dt: CGFloat) {
    }

}
