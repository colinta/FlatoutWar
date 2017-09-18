////
///  GuardNode.swift
//

private let StartingHealth: Float = 35

class GuardNode: Node, DraggableNode {
    var preferredAngle: CGFloat?

    var movementUpgrade: HasUpgrade = .false { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .false { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var radarUpgrade: HasUpgrade = .false { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }

    let armyComponent = SelectableArmyComponent()

    fileprivate func updateBaseSprite() {
        baseSprite.textureId(.guardNode(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.guardNode(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: 100))
    }
    fileprivate func updateRadarSprite() {
        radarSprite.textureId(.guardRadar(upgrade: radarUpgrade, isSelected: armyComponent.isCurrent))
    }
    fileprivate func updateUpgrades() {
        turretSprite.textureId(.guardTurret(upgrade: bulletUpgrade))
        updateBaseSprite()
        updateRadarSprite()

        if currentSpinRate == 0 {
            currentSpinRate = movementUpgrade.shotgunTurretSlowSpinRate
        }
        draggableComponent?.speed = movementUpgrade.shotgunMovementSpeed

        enemyTargetingComponent?.sweepAngle = radarUpgrade.shotgunSweepAngle
        enemyTargetingComponent?.radius = radarUpgrade.shotgunRadarRadius
        enemyTargetingComponent?.bulletSpeed = bulletUpgrade.shotgunBulletSpeed

        firingComponent?.targetsPreemptively = true
        firingComponent?.cooldown = calculateFiringCooldown()
        firingComponent?.damage = bulletUpgrade.shotgunBulletDamage

        get(component: RotateScanComponent.self)?.rate = movementUpgrade.shotgunScanSpinRate

        size = CGSize(30)
    }

    let radarSprite = SKSpriteNode()
    let baseSprite = SKSpriteNode()
    let turretSprite = SKSpriteNode()
    let placeholder = SKSpriteNode()
    var playerNode: SKNode?

    var isRotating = false
    var targetSpinRate: CGFloat = 0
    var currentSpinRate: CGFloat = 0

    required init() {
        super.init()

        self << placeholder
        placeholder.alpha = 0.5
        placeholder.isHidden = true

        radarSprite.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .player
        turretSprite.z = .abovePlayer
        radarSprite.z = .belowPlayer

        self << baseSprite
        self << radarSprite
        self << turretSprite

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseSprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.turret = radarSprite
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFireAngle(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: StartingHealth)
        healthComponent.onHurt { damage in
            self.updateBaseSprite()
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .circle)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isCurrentSelected = $0 }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        draggableComponent.bindTo(touchableComponent: touchableComponent)
        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            if !isMoving {
                let angle: CGFloat
                if let playerNode = self.playerNode {
                    angle = playerNode.convertPosition(self).angle
                }
                else if let preferredAngle = self.preferredAngle {
                    angle = preferredAngle
                }
                else {
                    angle = self.position.angle
                }
                self.setRotation(angle)
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        let keepRotatingComponent = KeepRotatingComponent()
        keepRotatingComponent.applyTo = turretSprite
        addComponent(keepRotatingComponent)

        let rotateScanComponent = RotateScanComponent()
        rotateScanComponent.applyTo = radarSprite
        addComponent(rotateScanComponent)

        let cursor = CursorNode()
        self << cursor

        armyComponent.cursorNode = cursor
        armyComponent.radarNode = radarSprite
        armyComponent.onUpdated { _ in
            self.updateRadarSprite()
        }
        addComponent(armyComponent)

        updateUpgrades()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func clone() -> Node {
        let node = super.clone() as! GuardNode
        node.movementUpgrade = movementUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        updateRotatingRate(dt)
        get(component: RotateScanComponent.self)?.enabled = currentSpinRate == movementUpgrade.shotgunTurretSlowSpinRate
        get(component: KeepRotatingComponent.self)?.rate = currentSpinRate
        firingComponent?.cooldown = calculateFiringCooldown()
    }

    fileprivate func calculateFiringCooldown() -> CGFloat {
        return interpolate(currentSpinRate,
            from: (movementUpgrade.shotgunTurretSlowSpinRate, movementUpgrade.shotgunTurretFastSpinRate),
            to: (movementUpgrade.shotgunSlowCooldown, movementUpgrade.shotgunFastCooldown)
            )
    }

    fileprivate func updateRotatingRate(_ dt: CGFloat) {
        var accel: CGFloat = movementUpgrade.shotgunWarmupRate * dt
        let hasTarget = enemyTargetingComponent?.currentTarget != nil
        if hasTarget {
            targetSpinRate = movementUpgrade.shotgunTurretFastSpinRate
        }
        else {
            targetSpinRate = movementUpgrade.shotgunTurretSlowSpinRate
            accel /= 3
        }
        currentSpinRate = moveValue(currentSpinRate, towards: targetSpinRate, by: accel) ?? targetSpinRate
    }
}

// MARK: Fire Bullet
extension GuardNode {
    fileprivate func fireBullet(angle: CGFloat) {
        guard let world = world else { return }

        let velocity: CGFloat = bulletUpgrade.shotgunBulletSpeed ± rand(weighted: 5)
        let bullet = BulletNode(velocity: CGPoint(r: velocity, a: angle), style: .slow)
        bullet.position = self.position
        bullet.timeRate = self.timeRate

        bullet.size = BulletArtist.bulletSize(upgrade: .false)
        bullet.zRotation = angle
        bullet.damage = bulletUpgrade.shotgunBulletDamage + rand(weighted: 0.25)
        (parentNode ?? world) << bullet

        _ = world.channel?.play(Sound.PlayerShoot)
    }
}

// MARK: Rotation
extension GuardNode {
    override func setRotation(_ angle: CGFloat) {
        radarSprite.zRotation = angle
        get(component: RotateScanComponent.self)?.reorient()
    }
}
