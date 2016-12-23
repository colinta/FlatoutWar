////
///  DroneNode.swift
//

private let startingHealth: Float = 40

class DroneNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var bulletUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var speedUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }

    fileprivate func updateUpgrades() {
        sprite.textureId(.Drone(speedUpgrade: speedUpgrade, radarUpgrade: radarUpgrade, bulletUpgrade: bulletUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.Drone(speedUpgrade: speedUpgrade, radarUpgrade: radarUpgrade, bulletUpgrade: bulletUpgrade, health: 100))
        radar1.textureId(.DroneRadar(upgrade: radarUpgrade))
        radar2.textureId(.DroneRadar(upgrade: radarUpgrade))

        targetingComponent?.radius = radarUpgrade.droneRadarRadius
        targetingComponent?.bulletSpeed = bulletUpgrade.droneBulletSpeed

        draggableComponent?.speed = speedUpgrade.droneMovementSpeed

        firingComponent?.cooldown = speedUpgrade.droneCooldown
        firingComponent?.targetsPreemptively = radarUpgrade.targetsPreemptively
        firingComponent?.damage = bulletUpgrade.droneBulletDamage

        wanderingComponent?.maxSpeed = speedUpgrade.droneMovementSpeed / 10
    }

    var wanderingEnabled: Bool? {
        didSet {
            if let wanderingEnabled = wanderingEnabled {
                wanderingComponent!.enabled = wanderingEnabled
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

    var cursor = CursorNode()
    let scale1 = SKSpriteNode()
    let radar1 = SKSpriteNode()
    let scale2 = SKSpriteNode()
    let radar2 = SKSpriteNode()
    var sprite = SKSpriteNode()
    let placeholder = SKSpriteNode()

    override var position: CGPoint {
        didSet {
            wanderingComponent?.centeredAround = position
        }
    }

    override func clone() -> Node {
        let node = super.clone() as! DroneNode
        node.radarUpgrade = radarUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.speedUpgrade = speedUpgrade
        return node
    }

    required init() {
        super.init()

        size = sprite.size

        self << sprite
        self << cursor
        self << placeholder

        placeholder.alpha = 0.5
        placeholder.isHidden = true

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        let phaseComponent = PhaseComponent()
        phaseComponent.loops = true
        phaseComponent.phase = rand(1)
        phaseComponent.duration = 3.333
        addComponent(phaseComponent)

        scale1 << radar1
        self << scale1
        scale2 << radar2
        self << scale2

        let wanderingComponent = WanderingComponent()
        wanderingComponent.centeredAround = position
        wanderingComponent.wanderingRadius = 10
        addComponent(wanderingComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.sweepAngle = nil
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFire(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            _ = self.world?.channel?.play(Sound.PlayerHurt)
            self.sprite.textureId(.Drone(speedUpgrade: self.speedUpgrade, radarUpgrade: self.radarUpgrade, bulletUpgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.droneEnabled(isMoving: false)
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Square)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        draggableComponent.bindTo(touchableComponent: touchableComponent)
        draggableComponent.onDragging { (isDragging, location) in
            wanderingComponent.enabled = !isDragging
        }
        draggableComponent.onDragChange { isMoving in
            self.droneEnabled(isMoving: isMoving)
            self.world?.unselectNode(self)
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        updateUpgrades()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        touchableComponent?.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Square)
        cursor = coder.decode(key: "cursor") ?? cursor
        sprite = coder.decode(key: "sprite") ?? sprite
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
        encoder.encode(cursor, forKey: "cursor")
        encoder.encode(sprite, forKey: "sprite")
    }

    override func update(_ dt: CGFloat) {
        let phase: CGFloat
        if selectableComponent!.selected {
            phase = 0.9
            phaseComponent!.phase = phase
        }
        else {
            phase = phaseComponent!.phase
        }

        if phase >= 0.5 && phase <= 0.9 {
            let scale = easeOutExpo(time: interpolate(phase, from: (0.5, 0.9), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.5, 0.9), to: (0.5, 0))
            scale1.setScale(scale)
            scale1.alpha = alpha
        }
        else {
            scale1.alpha = 0
        }

        if phase >= 0.6 {
            let scale = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.6, 1.0), to: (0.5, 0))
            scale2.setScale(scale)
            scale2.alpha = alpha
        }
        else {
            scale2.alpha = 0
        }
    }
}

extension DroneNode {
    func droneEnabled(isMoving: Bool) {
        let died = healthComponent!.died
        selectableComponent?.enabled = !died
        draggableComponent?.enabled = !died
        touchableComponent?.enabled = !died && (touchableEnabled ?? true)
        phaseComponent?.loops = !died

        let enabled = !isMoving && !died
        alpha = enabled ? 1 : 0.5
        if cursor.selected && !enabled {
            cursor.selected = false
        }

        playerComponent?.intersectable = enabled
        firingComponent?.enabled = enabled
        selectableComponent?.enabled = enabled
        wanderingComponent?.enabled = enabled && (wanderingEnabled ?? true)
    }
}

// MARK: Fire Bullet

extension DroneNode {
    fileprivate func fireBullet(angle: CGFloat) {
        guard let world = world else { return }

        let speed: CGFloat = bulletUpgrade.droneBulletSpeed
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position

        bullet.damage = bulletUpgrade.droneBulletDamage
        bullet.size = BulletArtist.bulletSize(upgrade: .False)
        bullet.zRotation = angle
        bullet.z = Z.Below
        firingComponent?.damage = bullet.damage
        (parentNode ?? world) << bullet

        _ = world.channel?.play(Sound.PlayerShoot)
    }
}

// MARK: Touch events

extension DroneNode {
    func onSelected(_ selected: Bool) {
        cursor.selected = selected
    }
}
