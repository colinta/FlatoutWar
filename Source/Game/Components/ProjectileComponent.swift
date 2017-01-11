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
    typealias OnCollision = (Node, CGPoint) -> Void
    var _onCollision: [OnCollision] = []
    func onCollision(_ handler: @escaping OnCollision) { _onCollision << handler }

    override func reset() {
        super.reset()
        _onCollision = []
    }

    required override init() {
        super.init()
    }

    override func didAddToNode() {
        super.didAddToNode()
        if intersectionNode == nil {
            fatalError("intersectionNode is required")
        }
    }

    override func update(_ dt: CGFloat) {
        guard let world = node.world else {
            return
        }

        for enemy in world.enemies where enemy.enemyComponent!.targetable {
            if let died = enemy.healthComponent?.died, died { continue }

            if intersectionNode!.intersects(enemy.enemyComponent!.intersectionNode!)
            {
                if let location = node.touchingLocation(enemy) {
                    for handler in _onCollision {
                        handler(enemy, location)
                    }

                    enemy.enemyComponent!.attacked(by: node)
                    break
                }
            }
        }
    }

}
