////
///  CannonNode.swift
//

private let startingHealth: Float = 50

class CannonNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var bulletUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var rotateUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }

    let moveTurret = MoveToComponent()
    let fadeRadar = FadeToComponent()

    fileprivate func updateUpgrades() {
        radarNode.textureId(.CannonRadar(upgrade: radarUpgrade))
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

    let cursor = CursorNode()
    let radarNode = SKSpriteNode()
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

        radarNode.position = CGPoint(x: -5)
        radarNode.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .Player
        radarNode.z = .BelowPlayer
        turretBox.z = .Above

        self << baseNode
        self << cursor
        self << radarNode
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
        firingComponent.onFireTarget(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.Cannon(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.cannonEnabled(isMoving: false)
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
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        touchableComponent.on(.DragBeganInside, draggableComponent.draggingBegan)
        touchableComponent.on(.DragEnded, draggableComponent.draggingEnded)
        touchableComponent.onDragged(draggableComponent.draggingMoved)

        draggableComponent.onDragChange { isMoving in
            self.cannonEnabled(isMoving: isMoving)
            self.world?.unselectNode(self)
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = baseNode
        addComponent(rotateToComponent)

        self.addComponent(moveTurret, assign: false)
        self.addComponent(fadeRadar)

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
            radarNode.zRotation = angle
        }

        turretNode.zRotation = firingComponent?.angle ?? baseNode.zRotation
        turretBox.zRotation = turretNode.zRotation
    }
}

// MARK: Enable/Disable during moving/death
extension CannonNode {
    func cannonEnabled(isMoving: Bool) {
        let died = healthComponent!.died
        selectableComponent?.enabled = !died
        touchableComponent?.enabled = !died

        let enabled = !isMoving && !died
        alpha = enabled ? 1 : 0.5
        if cursor.selected && !enabled {
            cursor.selected = false
        }

        playerComponent?.intersectable = enabled
        firingComponent?.enabled = enabled
        selectableComponent?.enabled = enabled

        fadeRadar.applyTo = radarNode
        fadeRadar.target = isMoving ? 0 : 1
        fadeRadar.rate = 3.333
    }
}

// MARK: Fire Bullet
extension CannonNode {
    fileprivate func fireBullet(target: CGPoint) {
        guard let world = world else { return }

        turretCenterSprite.position = CGPoint(x: -10)
        moveTurret.applyTo = turretCenterSprite
        moveTurret.target = .zero
        moveTurret.duration = bulletUpgrade.cannonCooldown

        for sprite in turretSprites {
            let delta = CGPoint(r: sprite.position.y, a: baseNode.zRotation + TAU_4)
            let start = position + delta
            let myTarget = target + delta
            let speed: CGFloat = bulletUpgrade.cannonBulletSpeed ± rand(10)
            let bullet = CannonballNode(from: start, to: self.position + myTarget, speed: speed, radius: bulletUpgrade.cannonBulletRadius)
            bullet.damage = bulletUpgrade.cannonBulletDamage
            bullet.size = BulletArtist.bulletSize(upgrade: .False)
            bullet.zRotation = myTarget.angle
            bullet.z = Z.Below
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

    func onSelected(_ selected: Bool) {
        cursor.selected = selected
    }
}

// MARK: Rotation
extension CannonNode {
    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(_ angle: CGFloat) {
        baseNode.zRotation = angle
        radarNode.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }
}
