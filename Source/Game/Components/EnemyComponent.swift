////
///  EnemyComponent.swift
//

class EnemyComponent: Component {
    private var _targetable: Bool = true
    var targetable: Bool {
        get { return _targetable && enabled }
        set { _targetable = newValue }
    }
    var experience: Int = 0
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == .zero {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }

    typealias OnAttacked = ((projectile: Node)) -> Void
    var _onAttacked: [OnAttacked] = []
    func onAttacked(_ handler: @escaping OnAttacked) { _onAttacked.append(handler) }

    override func reset() {
        super.reset()
        _onAttacked = []
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

    override func didAddToNode() {
        super.didAddToNode()
        if intersectionNode == nil {
            fatalError("intersectionNode is required")
        }
    }

    func attacked(by node: Node) {
        for handler in _onAttacked {
            handler(node)
        }
    }

}
