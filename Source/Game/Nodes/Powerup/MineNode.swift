////
///  MineNode.swift
//

private let NumFragments = 5

class MineNode: Node {
    let sprite = SKSpriteNode(id: .Mine)

    required init() {
        super.init()
        size = sprite.size
        self << sprite

        let projectileComponent = ProjectileComponent()
        projectileComponent.intersectionNode = sprite
        projectileComponent.damage = 10
        projectileComponent.onCollision { (enemy, location) in
            if let world = self.world {
                NumFragments.times { (i: Int) in
                    let angle = CGFloat(i) * TAU / CGFloat(NumFragments)
                    let absLocation = world.convertPoint(location, fromNode: self)
                    let fragmentNode = MineFragmentNode(angle: angle)
                    fragmentNode.position = absLocation
                    world << fragmentNode
                }
            }
            self.removeFromParent()
        }
        addComponent(projectileComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
