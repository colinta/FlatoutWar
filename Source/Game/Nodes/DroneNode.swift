////
///  DroneNode.swift
//

private let startingHealth: Float = 40

class DroneNode: Node, DraggableNode {
    static let DefaultSpeed: CGFloat = 40

    var radarUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var bulletUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var speedUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    private func updateUpgrades() {
        targetingComponent?.radius = radarUpgrade.droneRadarRadius
        targetingComponent?.bulletSpeed = bulletUpgrade.droneBulletSpeed
        draggableComponent?.speed = speedUpgrade.droneMovementSpeed
        updateSprites()
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

    private func updateSprites() {
        sprite.textureId(.Drone(speedUpgrade: speedUpgrade, radarUpgrade: radarUpgrade, bulletUpgrade: bulletUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.Drone(speedUpgrade: speedUpgrade, radarUpgrade: radarUpgrade, bulletUpgrade: bulletUpgrade, health: 100))
        radar1.textureId(.DroneRadar(upgrade: radarUpgrade))
        radar2.textureId(.DroneRadar(upgrade: radarUpgrade))
    }

    var cursor = CursorNode()
    let radar1 = SKSpriteNode()
    let radar2 = SKSpriteNode()
    var sprite = SKSpriteNode()
    let placeholder = SKSpriteNode()

    override var position: CGPoint {
        didSet {
            wanderingComponent?.centeredAround = position
        }
    }

    required init() {
        super.init()

        size = sprite.size

        self << sprite
        self << cursor
        self << placeholder

        placeholder.alpha = 0.5
        placeholder.hidden = true

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        let phaseComponent = PhaseComponent()
        phaseComponent.loops = true
        phaseComponent.phase = rand(1)
        phaseComponent.duration = 3.333
        addComponent(phaseComponent)

        self << radar1
        self << radar2

        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 10
        addComponent(wanderingComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.sweepAngle = nil
        targetingComponent.radius = radarUpgrade.droneRadarRadius
        targetingComponent.bulletSpeed = bulletUpgrade.droneBulletSpeed
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.cooldown = 0.4
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.sprite.textureId(.Drone(speedUpgrade: self.speedUpgrade, radarUpgrade: self.radarUpgrade, bulletUpgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.droneEnabled(isMoving: false)
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Square)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        draggableComponent.speed = speedUpgrade.droneMovementSpeed
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

        updateSprites()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        touchableComponent?.containsTouchTest = TouchableComponent.defaultTouchTest(.Square)
        cursor = coder.decode("cursor") ?? cursor
        sprite = coder.decode("sprite") ?? sprite
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(cursor, key: "cursor")
        encoder.encode(sprite, key: "sprite")
    }

    override func update(dt: CGFloat) {
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
            radar1.setScale(scale / Artist.Scale.Default.drawScale)
            radar1.alpha = alpha
        }
        else {
            radar1.alpha = 0
        }

        if phase >= 0.6 {
            let scale = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.6, 1.0), to: (0.5, 0))
            radar2.setScale(scale / Artist.Scale.Default.drawScale)
            radar2.alpha = alpha
        }
        else {
            radar2.alpha = 0
        }
    }

}

extension DroneNode {

    func droneEnabled(isMoving isMoving: Bool) {
        let died = healthComponent!.died
        self.selectableComponent!.enabled = !died
        self.draggableComponent!.enabled = !died
        self.touchableComponent!.enabled = !died && (touchableEnabled ?? true)
        self.phaseComponent!.loops = !died

        let enabled = !isMoving && !died
        self.alpha = died ? 0.5 : 0
        self.alpha = enabled ? 1 : 0.5
        if self.cursor.selected && !enabled {
            self.cursor.selected = false
        }

        playerComponent!.intersectable = enabled
        firingComponent!.enabled = enabled
        selectableComponent!.enabled = enabled
        wanderingComponent!.enabled = enabled && (wanderingEnabled ?? true)
    }
}

// MARK: Fire Bullet

extension DroneNode {

    private func fireBullet(angle angle: CGFloat) {
        guard let world = world else {
            return
        }

        let speed: CGFloat = bulletUpgrade.droneBulletSpeed
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position

        bullet.damage = bulletUpgrade.droneBulletDamage
        bullet.size = BulletArtist.bulletSize(.False)
        bullet.zRotation = angle
        bullet.z = Z.Below
        ((parent as? Node) ?? world) << bullet
    }

}

// MARK: Touch events

extension DroneNode {

    func onSelected(selected: Bool) {
        cursor.selected = selected
    }

}

extension HasUpgrade {

    var droneRadarRadius: CGFloat {
        switch self {
        case .False: return 75
        case .True: return 100
        }
    }

    var droneBulletSpeed: CGFloat {
        switch self {
        case .False: return 125
        case .True: return 150
        }
    }

    var droneBulletDamage: Float {
        switch self {
        case .False: return 1
        case .True: return 1.25
        }
    }

    var droneMovementSpeed: CGFloat {
        switch self {
        case .False: return 40
        case .True: return 60
        }
    }

}
