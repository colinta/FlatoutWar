////
///  PlayerComponent.swift
//

class PlayerComponent: Component {
    enum Rammed {
        case Damaged
        case Attacks
    }

    var intersectable: Bool = true
    var targetable: Bool = true
    var rammedBehavior: Rammed = .Damaged
    weak var intersectionNode: SKNode!

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func reset() {
        super.reset()
    }

    override func didAddToNode() {
        super.didAddToNode()
        if intersectionNode == nil {
            fatalError("intersectionNode is required")
        }
    }

    override func update(_ dt: CGFloat) {
    }

}
