////
///  MissleNode.swift
//

private let RotationRate: CGFloat = 5

class MissleNode: Node {
    private var sprite = SKSpriteNode(id: .Missle)
    private var circlingDirection: CGFloat?
    private var circlingAngle: CGFloat = 0
    private var timeout: CGFloat = 8

    private var splashDamage: Float = 0
    private var splashRadius: Int = 0

    convenience init(damage: Float, speed: CGFloat, radius: Int, target initialTarget: Node) {
        self.init()

        splashDamage = damage
        splashRadius = radius

        enemyTargetingComponent?.currentTarget = initialTarget
        rammingComponent?.currentTarget = initialTarget
        rammingComponent?.maxSpeed = speed
        rammingComponent?.maxTurningSpeed = speed
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    required init() {
        super.init()

        sprite.z = .AbovePlayer
        self << sprite

        size = CGSize(10, 7)

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.radius = 200
        addComponent(targetingComponent)

        let rammingComponent = EnemyRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        rammingComponent.onRammed { enemy in
            self.explode()
        }
        addComponent(rammingComponent)

        let rotateComponent = RotateToComponent()
        rotateComponent.angularAccel = nil
        rotateComponent.maxAngularSpeed = RotationRate
        addComponent(rotateComponent)
    }

    override func update(_ dt: CGFloat) {
        timeout -= dt
        guard timeout > 0 else {
            explode()
            return
        }

        if enemyTargetingComponent?.currentTarget == nil {
            let speed = rammingComponent!.maxSpeed
            let radius = speed / RotationRate
            let direction: CGFloat
            if let circlingDirection = circlingDirection {
                direction = circlingDirection
            }
            else {
                let newDirection: CGFloat = ±1
                direction = newDirection
                circlingDirection = newDirection
                circlingAngle = 0
            }

            let dTheta = RotationRate * dt
            circlingAngle += dTheta
            if circlingAngle > TAU {
                circlingDirection = nil
            }
            let dist = radius * sin(dTheta)
            let newAngle = zRotation + direction * dTheta
            let newVector = CGPoint(r: dist, a: newAngle)
            self.position += newVector
            self.zRotation = newAngle

            rotateToComponent?.target = nil
        }
        else {
            circlingDirection = nil
        }
    }

    func explode() {
        guard let parent = (self.parentNode ?? self.world) else { return }

        let bomb = BombNode(maxRadius: splashRadius)
        bomb.damage = splashDamage
        bomb.position = position
        parent << bomb

        removeFromParent()
    }

}
