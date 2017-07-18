////
///  MineNode.swift
//

private let NumFragments = 5

class MineNode: Node {
    let sprite = SKSpriteNode(id: .mine)

    required init() {
        super.init()
        size = sprite.size
        self << sprite

        let projectileComponent = ProjectileComponent()
        projectileComponent.intersectionNode = sprite
        projectileComponent.damage = 4
        projectileComponent.onCollision { (enemy, location) in
            if let world = self.world {
                NumFragments.times { (i: Int) in
                    let angle = CGFloat(i) * TAU / CGFloat(NumFragments)
                    let absLocation = world.convert(location, from: self)
                    let fragmentNode = MineFragmentNode(angle: angle)
                    fragmentNode.position = absLocation
                    world << fragmentNode
                }
            }
            self.removeFromParent()
        }
        addComponent(projectileComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
