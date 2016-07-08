////
///  ProjectileComponent.swift
//

class ProjectileComponent: Component {
    var damage: Float = 0
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == .zero {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }
    typealias OnCollision = (enemy: Node, location: CGPoint) -> Void
    var _onCollision: [OnCollision] = []
    func onCollision(handler: OnCollision) { _onCollision << handler }

    override func reset() {
        super.reset()
        _onCollision = []
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func didAddToNode() {
        super.didAddToNode()
        if intersectionNode == nil {
            fatalError("intersectionNode is required")
        }
    }

    override func update(dt: CGFloat) {
        guard let world = node.world else {
            return
        }

        for enemy in world.enemies where enemy.enemyComponent!.targetable {
            if let died = enemy.healthComponent?.died where died { continue }

            if intersectionNode!.intersectsNode(enemy.enemyComponent!.intersectionNode!)
            {
                if let location = node.touchingLocation(enemy) {
                    for handler in _onCollision {
                        handler(enemy: enemy, location: location)
                    }

                    enemy.enemyComponent!.attacked(by: node)
                    break
                }
            }
        }
    }

}
