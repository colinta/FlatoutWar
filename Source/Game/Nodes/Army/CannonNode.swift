////
///  CannonNode.swift
//

private let startingHealth: Float = 50

class CannonNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var bulletUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var rotateUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }

    let moveTurret = MoveToComponent()
    let armyComponent = SelectableArmyComponent()

    fileprivate func updateUpgrades() {
        radarSprite.textureId(.CannonRadar(upgrade: radarUpgrade))
        baseSprite.textureId(.Cannon(upgrade: bulletUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.Cannon(upgrade: bulletUpgrade, health: 100))
        turretBox.textureId(.CannonBox(upgrade: bulletUpgrade))
        for turretSprite in turretSprites {
            turretSprite.textureId(.CannonTurret(upgrade: bulletUpgrade))
        }

        draggableComponent?.speed = rotateUpgrade.cannonMovementSpeed

        targetingComponent?.sweepAngle = radarUpgrade.cannonSweepAngle
        targetingComponent?.minRadius = radarUpgrade.cannonMinRadarRadius
        targetingComponent?.radius = radarUpgrade.cannonMaxRadarRadius

        firingComponent?.targetsPreemptively = true
        firingComponent?.cooldown = bulletUpgrade.cannonCooldown
        firingComponent?.damage = bulletUpgrade.cannonBulletDamage

        rotateToComponent?.maxAngularSpeed = rotateUpgrade.baseAngularSpeed
        rotateToComponent?.angularAccel = rotateUpgrade.baseAngularAccel

        targetingComponent?.bulletSpeed = bulletUpgrade.cannonBulletSpeed
        size = baseSprite.size
    }

    let radarSprite = SKSpriteNode()
    let baseNode = Node()
    let baseSprite = SKSpriteNode()
    let turretNode = Node()
    let turretBox = SKSpriteNode()
    let turretCenterSprite = SKNode()
    let turretSprites = [
        SKSpriteNode(), SKSpriteNode()
    ]
    let placeholder = SKSpriteNode()

    var isDragging = false

    required init() {
        super.init()

        self << placeholder
        placeholder.alpha = 0.5
        placeholder.isHidden = true

        radarSprite.position = CGPoint(x: -5)
        radarSprite.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .Player
        radarSprite.z = .BelowPlayer
        turretBox.z = .Above

        self << baseNode
        self << radarSprite
        baseNode << baseSprite
        self << turretNode
        turretNode << turretCenterSprite
        turretBox.anchorPoint = CGPoint(x: 0.75, y: 0.5)
        self << turretBox

        let dy: CGFloat = CGFloat(20 - 2) / CGFloat(turretSprites.count)
        var turretY: CGFloat = dy / 2 * CGFloat(turretSprites.count - 1)
        for turretSprite in turretSprites {
            turretSprite.anchorPoint = CGPoint(0.25, 0.5)
            turretSprite.z = .AbovePlayer
            turretSprite.position = CGPoint(y: turretY)
            turretCenterSprite << turretSprite
            turretY -= dy
        }

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseNode
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.turret = baseNode
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFirePosition(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.Cannon(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Circle)
        touchableComponent.on(.DragBeganOutside, onDraggingBegan)
        touchableComponent.on(.DragEnded, onDraggingEnded)
        touchableComponent.onDragged(onDraggedAiming)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isSelected = $0 }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        touchableComponent.on(.DragBeganInside, draggableComponent.draggingBegan)
        touchableComponent.on(.DragEnded, draggableComponent.draggingEnded)
        touchableComponent.onDragged(draggableComponent.draggingMoved)

        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = baseNode
        addComponent(rotateToComponent)

        let cursor = CursorNode()
        self << cursor

        armyComponent.cursorNode = cursor
        armyComponent.radarNode = radarSprite
        addComponent(armyComponent)

        addComponent(moveTurret, assign: false)

        updateUpgrades()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func clone() -> Node {
        let node = super.clone() as! CannonNode
        node.rotateUpgrade = rotateUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }

        let angle = firingComponent?.angle ?? baseNode.zRotation
        turretNode.zRotation = angle
        turretBox.zRotation = angle
    }
}

// MARK: Fire Bullet
extension CannonNode {
    fileprivate func fireBullet(enemyPosition: CGPoint) {
        guard let world = world else { return }

        turretCenterSprite.position = CGPoint(x: -10)
        moveTurret.applyTo = turretCenterSprite
        moveTurret.target = .zero
        moveTurret.duration = bulletUpgrade.cannonCooldown

        for sprite in turretSprites {
            let delta = CGPoint(r: sprite.position.y, a: baseNode.zRotation + TAU_4)
            let start = position + delta
            let myTarget = enemyPosition + delta
            let speed: CGFloat = bulletUpgrade.cannonBulletSpeed ± rand(weighted: 10)
            let bullet = CannonballNode(
                from: start,
                to: self.position + myTarget,
                speed: speed,
                radius: bulletUpgrade.cannonSplashRadius)
            bullet.damage = bulletUpgrade.cannonBulletDamage
            bullet.size = BulletArtist.bulletSize(upgrade: .False)
            bullet.zRotation = myTarget.angle
            (parentNode ?? world) << bullet
        }
    }
}

// MARK: Touch events
extension CannonNode {
    func onDraggingBegan(at location: CGPoint) {
        isDragging = true
    }
    func onDraggingEnded(at location: CGPoint) {
        isDragging = false
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        guard isDragging else { return }

        let angle = prevLocation.angleTo(location, around: position)
        let destAngle = rotateToComponent?.destAngle ?? 0
        startRotatingTo(angle: destAngle + angle)
    }
}

// MARK: Rotation
extension CannonNode {
    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(_ angle: CGFloat) {
        baseNode.zRotation = angle
        radarSprite.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }
}
