////
///  CannonNode.swift
//

private let StartingHealth: Float = 50

class CannonNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .false { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .false { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var movementUpgrade: HasUpgrade = .false { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }

    let moveTurret = MoveToComponent()
    let armyComponent = SelectableArmyComponent()

    fileprivate func updateRadarSprite() {
        radarSprite.textureId(.cannonRadar(upgrade: radarUpgrade, isSelected: armyComponent.isCurrent))
    }
    fileprivate func updateUpgrades() {
        turretBox.textureId(.cannonBox(upgrade: bulletUpgrade))
        for turretSprite in turretSprites {
            turretSprite.textureId(.cannonTurret(upgrade: bulletUpgrade))
        }
        baseSprite.textureId(.cannon(upgrade: movementUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.cannon(upgrade: movementUpgrade, health: 100))
        updateRadarSprite()

        draggableComponent?.speed = movementUpgrade.cannonMovementSpeed

        enemyTargetingComponent?.sweepAngle = radarUpgrade.cannonSweepAngle
        enemyTargetingComponent?.minRadius = radarUpgrade.cannonMinRadarRadius
        enemyTargetingComponent?.radius = radarUpgrade.cannonMaxRadarRadius
        enemyTargetingComponent?.bulletSpeed = bulletUpgrade.cannonBulletSpeed

        firingComponent?.targetsPreemptively = true
        firingComponent?.cooldown = bulletUpgrade.cannonCooldown
        firingComponent?.damage = bulletUpgrade.cannonBulletDamage

        rotateToComponent?.maxAngularSpeed = movementUpgrade.cannonAngularSpeed
        rotateToComponent?.angularAccel = movementUpgrade.cannonAngularAccel

        size = CGSize(30)
    }

    let radarSprite = SKSpriteNode()
    let baseSprite = SKSpriteNode()
    let turretNode = Node()
    let turretBox = SKSpriteNode()
    let turretCenterSprite = SKNode()
    let turretSprites = [
        SKSpriteNode(), SKSpriteNode()
    ]
    let placeholder = SKSpriteNode()

    var isRotating = false

    required init() {
        super.init()

        self << placeholder
        placeholder.alpha = 0.5
        placeholder.isHidden = true

        radarSprite.position = CGPoint(x: -5)
        radarSprite.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .player
        radarSprite.z = .belowPlayer
        turretBox.z = .above

        self << baseSprite
        self << radarSprite
        self << turretNode
        turretNode << turretCenterSprite
        turretBox.anchorPoint = CGPoint(x: 0.75, y: 0.5)
        self << turretBox

        let dy: CGFloat = CGFloat(20 - 2) / CGFloat(turretSprites.count)
        var turretY: CGFloat = dy / 2 * CGFloat(turretSprites.count - 1)
        for turretSprite in turretSprites {
            turretSprite.anchorPoint = CGPoint(0.25, 0.5)
            turretSprite.z = .abovePlayer
            turretSprite.position = CGPoint(y: turretY)
            turretCenterSprite << turretSprite
            turretY -= dy
        }

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseSprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.turret = baseSprite
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFirePosition(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: StartingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.cannon(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .circle)
        touchableComponent.on(.dragBeganOutside, onDraggingOutside)
        touchableComponent.on(.dragEnded, onDraggingEnded)
        touchableComponent.onDragged(onDraggedAiming)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isCurrentSelected = $0 }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        touchableComponent.on(.dragBeganInside, draggableComponent.draggingBegan)
        touchableComponent.on(.dragEnded, draggableComponent.draggingEnded)
        touchableComponent.onDragged(draggableComponent.draggingMoved)

        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.applyTo = baseSprite
        addComponent(rotateToComponent)

        let cursor = CursorNode()
        self << cursor

        armyComponent.cursorNode = cursor
        armyComponent.radarNode = radarSprite
        armyComponent.onUpdated { _ in
            self.updateRadarSprite()
        }
        addComponent(armyComponent)

        addComponent(moveTurret, assign: false)

        updateUpgrades()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func clone() -> Node {
        let node = super.clone() as! CannonNode
        node.movementUpgrade = movementUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }

        let angle = firingComponent?.angle ?? baseSprite.zRotation
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
            let delta = CGPoint(r: sprite.position.y, a: baseSprite.zRotation + TAU_4)
            let start = position + delta
            let myTarget = enemyPosition + delta
            let speed: CGFloat = bulletUpgrade.cannonBulletSpeed ± rand(weighted: 10)
            let bullet = CannonballNode(
                from: start,
                to: self.position + myTarget,
                speed: speed,
                radius: bulletUpgrade.cannonSplashRadius)
            bullet.damage = bulletUpgrade.cannonBulletDamage
            bullet.size = BulletArtist.bulletSize(upgrade: .false)
            bullet.timeRate = self.timeRate
            bullet.zRotation = myTarget.angle
            (parentNode ?? world) << bullet
        }
    }
}

// MARK: Touch events
extension CannonNode {
    func onDraggingOutside(at location: CGPoint) {
        isRotating = true
    }
    func onDraggingEnded(at location: CGPoint) {
        isRotating = false
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        guard isRotating else { return }

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

    override func setRotation(_ angle: CGFloat) {
        baseSprite.zRotation = angle
        radarSprite.zRotation = angle
        turretNode.zRotation = angle
        turretBox.zRotation = angle
        rotateToComponent?.target = nil
    }
}
