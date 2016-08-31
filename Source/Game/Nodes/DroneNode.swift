////
///  DroneNode.swift
//

private let startingHealth: Float = 40

class DroneNode: Node, DraggableNode {
    static let DefaultSpeed: CGFloat = 40

    var upgrade: FiveUpgrades = .One {
        didSet {
            targetingComponent?.radius = upgrade.droneRadarRadius
            targetingComponent?.bulletSpeed = upgrade.droneBulletSpeed
            updateSprites()
        }
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
        sprite.textureId(.Drone(upgrade: upgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.Drone(upgrade: upgrade, health: 100))
        radar1.textureId(.DroneRadar(upgrade: upgrade))
        radar2.textureId(.DroneRadar(upgrade: upgrade))
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

        sprite.textureId(.Drone(upgrade: upgrade, health: 100))
        placeholder.textureId(.Drone(upgrade: upgrade, health: 100))
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
        targetingComponent.radius = upgrade.droneRadarRadius
        targetingComponent.bulletSpeed = upgrade.droneBulletSpeed
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.cooldown = 0.4
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.sprite.textureId(.Drone(upgrade: self.upgrade, health: healthComponent.healthInt))
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
        draggableComponent.speed = DroneNode.DefaultSpeed
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
            radar1.setScale(scale / Artist.Scale.Default.scale)
            radar1.alpha = alpha
        }
        else {
            radar1.alpha = 0
        }

        if phase >= 0.6 {
            let scale = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.6, 1.0), to: (0.5, 0))
            radar2.setScale(scale / Artist.Scale.Default.scale)
            radar2.alpha = alpha
        }
        else {
            radar2.alpha = 0
        }
    }

    override func applyUpgrade(upgradeType: UpgradeType) {
        switch upgradeType {
        case .Upgrade: upgrade = (upgrade + 1) ?? upgrade
        default: break
        }
    }

    override func availableUpgrades() -> [UpgradeInfo] {
        var upgrades: [UpgradeInfo] = []

        if let nextDroneUpgrade = upgrade + 1 {
            let upgrade = Node()
            upgrade << SKSpriteNode(id: .Drone(upgrade: nextDroneUpgrade, health: 100))

            let cost: Int
            switch nextDroneUpgrade {
                case .One: cost = 0
                case .Two: cost = 100
                case .Three: cost = 150
                case .Four: cost = 200
                case .Five: cost = 300
            }

            upgrades << (upgradeNode: upgrade, cost: cost, upgradeType: .Upgrade)
        }

        return upgrades
    }

}

extension DroneNode {

    func droneEnabled(isMoving isMoving: Bool) {
        let died = healthComponent!.died
        self.selectableComponent!.enabled = !died
        self.draggableComponent!.enabled = !died
        self.touchableComponent!.enabled = !died && (touchableEnabled ?? true)
        self.phaseComponent!.enabled = !died

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

        let speed: CGFloat = upgrade.droneBulletSpeed
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position

        bullet.damage = upgrade.droneBulletDamage
        bullet.size = BaseTurretBulletArtist.bulletSize(.One)
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

extension FiveUpgrades {

    var droneRadarRadius: CGFloat {
        switch self {
        case .One: return 75
        case .Two: return 85
        case .Three: return 95
        case .Four: return 105
        case .Five: return 135
        }
    }

    var droneBulletSpeed: CGFloat {
        switch self {
            case .One: return 125
            case .Two: return 125
            case .Three: return 125
            case .Four: return 125
            case .Five: return 125
        }
    }

    var droneBulletDamage: Float {
        switch self {
            case .One: return 1
            case .Two: return 1.1
            case .Three: return 1.2
            case .Four: return 1.3
            case .Five: return 1.6
        }
    }

}
