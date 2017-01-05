////
///  ShotgunNode.swift
//

private let startingHealth: Float = 35

class ShotgunNode: Node, DraggableNode {
    var movementUpgrade: HasUpgrade = .False { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .False { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var radarUpgrade: HasUpgrade = .False { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }

    let armyComponent = SelectableArmyComponent()

    fileprivate func updateBaseSprite() {
        baseSprite.textureId(.ShotgunNode(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.ShotgunNode(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: 100))
    }
    fileprivate func updateRadarSprite() {
        radarSprite.textureId(.ShotgunRadar(upgrade: radarUpgrade, isSelected: armyComponent.isSelected))
    }
    fileprivate func updateUpgrades() {
        turretSprite.textureId(.ShotgunTurret(upgrade: bulletUpgrade))
        updateBaseSprite()
        updateRadarSprite()

        draggableComponent?.speed = movementUpgrade.shotgunMovementSpeed

        targetingComponent?.sweepAngle = radarUpgrade.shotgunSweepAngle
        targetingComponent?.radius = radarUpgrade.shotgunRadarRadius

        firingComponent?.targetsPreemptively = true
        firingComponent?.cooldown = bulletUpgrade.shotgunCooldown
        firingComponent?.damage = bulletUpgrade.shotgunBulletDamage

        rotateToComponent?.maxAngularSpeed = movementUpgrade.shotgunAngularSpeed
        rotateToComponent?.angularAccel = movementUpgrade.shotgunAngularAccel

        targetingComponent?.bulletSpeed = bulletUpgrade.shotgunBulletSpeed

        size = CGSize(30)
    }

    let radarSprite = SKSpriteNode()
    let baseSprite = SKSpriteNode()
    let targetingSprite = SKNode()
    let turretSprite = SKSpriteNode()
    let placeholder = SKSpriteNode()

    var isRotating = false
    var spinnerTimeout: CGFloat = 0
    var targetSpinRate: CGFloat = 0
    var currentSpinRate: CGFloat = 0

    required init() {
        super.init()

        self << placeholder
        placeholder.alpha = 0.5
        placeholder.isHidden = true

        radarSprite.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .Player
        turretSprite.z = .AbovePlayer
        radarSprite.z = .BelowPlayer

        self << baseSprite
        self << targetingSprite
        self << radarSprite
        self << turretSprite

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseSprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.turret = targetingSprite
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFireAngle(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.updateBaseSprite()
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Circle)
        touchableComponent.on(.DragBeganOutside, onDraggingOutside)
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
        rotateToComponent.applyTo = targetingSprite
        addComponent(rotateToComponent)

        let keepRotatingComponent = KeepRotatingComponent()
        keepRotatingComponent.applyTo = turretSprite
        addComponent(keepRotatingComponent)

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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func clone() -> Node {
        let node = super.clone() as! ShotgunNode
        node.movementUpgrade = movementUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }

        if spinnerTimeout > 0 {
            spinnerTimeout -= dt
        }
        currentSpinRate = calculateRotatingRate(dt)
        firingComponent?.enabled = currentSpinRate == targetSpinRate
        get(component: KeepRotatingComponent.self)?.rate = currentSpinRate
    }

    fileprivate func calculateRotatingRate(_ dt: CGFloat) -> CGFloat {
        var accel: CGFloat = movementUpgrade.shotgunWarmupRate * dt
        if targetingComponent?.currentTarget != nil {
            targetSpinRate = movementUpgrade.shotgunTurretFastSpinRate
        }
        else {
            targetSpinRate = movementUpgrade.shotgunTurretSlowSpinRate
            accel /= 3
        }
        return moveValue(currentSpinRate, towards: targetSpinRate, by: accel) ?? targetSpinRate
    }
}

// MARK: Fire Bullet
extension ShotgunNode {
    fileprivate func fireBullet(angle: CGFloat) {
        guard let world = world else { return }

        let velocity: CGFloat = bulletUpgrade.shotgunBulletSpeed ± rand(weighted: 5)
        let bullet = BulletNode(velocity: CGPoint(r: velocity, a: angle), style: .Slow)
        bullet.position = self.position
        bullet.timeRate = self.timeRate

        bullet.size = BulletArtist.bulletSize(upgrade: .False)
        bullet.zRotation = angle
        bullet.damage = bulletUpgrade.shotgunBulletDamage + rand(weighted: 0.25)
        (parentNode ?? world) << bullet

        spinnerTimeout = bulletUpgrade.shotgunCooldown * 5

        _ = world.channel?.play(Sound.PlayerShoot)
    }
}

// MARK: Touch events
extension ShotgunNode {
    func onDraggingOutside(at location: CGPoint) {
        isRotating = true
    }
    func onDraggingEnded(at location: CGPoint) {
        isRotating = false
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        guard isRotating, let playerNode = playerNode else { return }

        let angle = prevLocation.angleTo(location, around: .zero)
        let destAngle = rotateToComponent?.destAngle ?? 0
        startRotatingTo(angle: destAngle + angle)
    }
}

// MARK: Rotation
extension ShotgunNode {
    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(_ angle: CGFloat) {
        targetingSprite.zRotation = angle
        radarSprite.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }
}
