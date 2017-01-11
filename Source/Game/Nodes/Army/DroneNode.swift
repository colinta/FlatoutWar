////
///  DroneNode.swift
//

private let startingHealth: Float = 40

class DroneNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .False { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .False { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var movementUpgrade: HasUpgrade = .False { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }

    let armyComponent = SelectableArmyComponent()
    let wanderingComponent = WanderingComponent()
    let phaseComponent = PhaseComponent()

    fileprivate func updateBaseSprite() {
        sprite.textureId(.Drone(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.Drone(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: 100))
    }
    fileprivate func updateUpgrades() {
        fixedRadar.textureId(.DroneRadar(upgrade: radarUpgrade))
        growingRadar.textureId(.DroneRadar(upgrade: radarUpgrade))
        updateBaseSprite()

        enemyTargetingComponent?.radius = radarUpgrade.droneRadarRadius
        enemyTargetingComponent?.bulletSpeed = bulletUpgrade.droneBulletSpeed

        draggableComponent?.speed = movementUpgrade.droneMovementSpeed

        firingComponent?.cooldown = movementUpgrade.droneCooldown
        firingComponent?.targetsPreemptively = radarUpgrade.targetsPreemptively
        firingComponent?.damage = bulletUpgrade.droneBulletDamage

        wanderingComponent.maxSpeed = movementUpgrade.droneMovementSpeed / 10

        size = CGSize(20)
    }

    var wanderingEnabled: Bool? {
        didSet {
            if let wanderingEnabled = wanderingEnabled {
                wanderingComponent.enabled = wanderingEnabled
            }
        }
    }
    var touchableEnabled: Bool? {
        didSet {
            if let touchableEnabled = touchableEnabled {
                touchableComponent!.enabled = touchableEnabled
            }
        }
    }

    let fixedRadar = SKSpriteNode()
    let scaleNode = SKSpriteNode()
    let growingRadar = SKSpriteNode()
    var sprite = SKSpriteNode()
    let placeholder = SKSpriteNode()

    override var position: CGPoint {
        didSet {
            wanderingComponent.centeredAround = position
        }
    }

    override func clone() -> Node {
        let node = super.clone() as! DroneNode
        node.radarUpgrade = radarUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.movementUpgrade = movementUpgrade
        return node
    }

    required init() {
        super.init()

        self << sprite
        self << placeholder

        placeholder.alpha = 0.5
        placeholder.isHidden = true

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        phaseComponent.loops = true
        phaseComponent.phase = rand(1)
        phaseComponent.duration = 3.333
        addComponent(phaseComponent)

        fixedRadar.alpha = 0.5
        self << fixedRadar
        scaleNode << growingRadar
        self << scaleNode

        wanderingComponent.centeredAround = position
        wanderingComponent.wanderingRadius = 10
        addComponent(wanderingComponent)

        let cursor = CursorNode()
        self << cursor

        armyComponent.cursorNode = cursor
        armyComponent.shootsWhileMoving = true
        armyComponent.onUpdated { armyEnabled in
            self.phaseComponent.loops = !self.healthComponent!.died
            self.wanderingComponent.enabled = armyEnabled && (self.wanderingEnabled ?? true)
        }
        addComponent(armyComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.sweepAngle = nil
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFireAngle(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            _ = self.world?.channel?.play(Sound.PlayerHurt)
            self.updateBaseSprite()
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Square)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isSelected = $0 }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        draggableComponent.bindTo(touchableComponent: touchableComponent)
        draggableComponent.onDragging { (isDragging, location) in
            self.wanderingComponent.enabled = !isDragging
        }
        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        updateUpgrades()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ dt: CGFloat) {
        let phase: CGFloat
        if selectableComponent!.selected {
            phase = 0.9
            phaseComponent.phase = phase
        }
        else {
            phase = phaseComponent.phase
        }

        if phase > 0.6 {
            let scale = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.6, 1.0), to: (0.5, 0))
            scaleNode.setScale(scale)
            scaleNode.alpha = alpha
        }
        else {
            scaleNode.alpha = 0
        }
    }
}

// MARK: Fire Bullet

extension DroneNode {
    fileprivate func fireBullet(angle: CGFloat) {
        guard let world = world else { return }

        let speed: CGFloat = bulletUpgrade.droneBulletSpeed ± rand(weighted: 5)
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position
        bullet.timeRate = self.timeRate

        bullet.damage = bulletUpgrade.droneBulletDamage + rand(weighted: 0.5)
        bullet.size = BulletArtist.bulletSize(upgrade: .False)
        bullet.zRotation = angle
        firingComponent?.damage = bullet.damage
        (parentNode ?? world) << bullet

        _ = world.channel?.play(Sound.PlayerShoot)
    }
}

// MARK: Rotation
extension DroneNode {
    func startRotatingTo(angle: CGFloat) {
    }

    override func rotateTo(_ angle: CGFloat) {
    }
}
