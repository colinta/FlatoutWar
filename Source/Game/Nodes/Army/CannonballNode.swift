////
///  CannonballNode.swift
//

class CannonballNode: Node {
    var damage: Float = 10
    let sprite = SKSpriteNode()

    required init(from start: CGPoint, to destination: CGPoint, speed: CGFloat, radius: Int) {
        super.init()
        position = start

        sprite.textureId(.bullet(upgrade: .false, style: .slow))
        sprite.z = .above
        self << sprite

        let scaleDuration = (destination - start).length / speed
        scaleTo(3, duration: scaleDuration, easing: .reverseQuad)
        moveTo(destination, speed: speed).onArrived {
            guard let parent = (self.parentNode ?? self.world) else { return }
            let bomb = BombNode(maxRadius: radius)
            bomb.damage = self.damage
            bomb.position = destination
            parent << bomb
            self.removeFromParent()
        }
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
