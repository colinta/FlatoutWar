//
//  DroneNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/22/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 40

class DroneNode: Node, DraggableNode, PlayerNode {
    static let DefaultSpeed: CGFloat = 30

    var upgrade: FiveUpgrades = .One {
        didSet {
            sprite.textureId(.Drone(upgrade: upgrade, health: healthComponent?.healthInt ?? 100))
            placeholder.textureId(.Drone(upgrade: upgrade, health: 100))
            targetingComponent?.radius = upgrade.droneRadarRadius
            targetingComponent?.bulletSpeed = upgrade.droneBulletSpeed
        }
    }
    var overrideWandering: Bool? {
        didSet {
            if let overrideWandering = overrideWandering {
                wanderingComponent!.enabled = overrideWandering
            }
        }
    }
    var overrideTouchable: Bool? {
        didSet {
            if let overrideTouchable = overrideTouchable {
                touchableComponent!.enabled = overrideTouchable
            }
        }
    }

    var cursor = CursorNode()
    let radar1 = SKShapeNode()
    let radar2 = SKShapeNode()
    var sprite = SKSpriteNode()
    let placeholder = SKSpriteNode()

    override var position: CGPoint {
        didSet {
            wanderingComponent?.centeredAround = position
        }
    }

    required init() {
        super.init()
        size = CGSize(20)

        sprite.textureId(.Drone(upgrade: upgrade, health: 100))
        placeholder.textureId(.Drone(upgrade: upgrade, health: 100))

        self << sprite
        self << cursor
        self << placeholder

        placeholder.alpha = 0.5
        placeholder.hidden = true

        let timeline = TimelineComponent()
        addComponent(timeline)

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = sprite
        addComponent(playerComponent)

        let phaseComponent = PhaseComponent()
        phaseComponent.phase = rand(1)
        phaseComponent.duration = rand(min: 2.5, max: 4.5)
        addComponent(phaseComponent)

        for radar in [radar1, radar2] {
            radar.lineWidth = 1.pixels
            radar.strokeColor = UIColor(hex: 0x25B1FF)
            self << radar
        }

        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 10
        addComponent(wanderingComponent)

        let targetingComponent = TargetingComponent()
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
            self.sprite.textureId(.Drone(upgrade: .One, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.droneEnabled(isMoving: false)

            timeline.after(20) {
                healthComponent.startingHealth = startingHealth
                self.sprite.textureId(.Drone(upgrade: .One, health: healthComponent.healthInt))
                self.droneEnabled(isMoving: false)
            }
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

        let radarRadius: CGFloat = targetingComponent!.radius!
        if phase <= 0.9 {
            let easedPhase = easeOutExpo(time: interpolate(phase, from: (0.5, 0.9), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.6, 0.8), to: (0.25, 0))
            radar1.alpha = alpha
            let path = CGPathCreateMutable()
            CGPathAddEllipseInRect(path, nil, CGPointZero.rectWithSize(CGSize(r: radarRadius * easedPhase)))
            radar1.path = path
        }
        else {
            radar1.alpha = 0
        }

        if phase > 0.6 {
            let easedPhase = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.8, 1.0), to: (0.25, 0))
            radar2.alpha = alpha
            let path = CGPathCreateMutable()
            CGPathAddEllipseInRect(path, nil, CGPointZero.rectWithSize(CGSize(r: radarRadius * easedPhase)))
            radar2.path = path
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
                case .Two: cost = 100
                case .Three: cost = 150
                case .Four: cost = 200
                case .Five: cost = 300
                default: cost = 0
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
        self.touchableComponent!.enabled = !died && (overrideTouchable ?? true)
        self.phaseComponent!.enabled = !died

        let enabled = !isMoving && !died

        firingComponent!.enabled = !died
        playerComponent!.targetable = !died
        self.alpha = died ? 0.5 : 0

        self.alpha = enabled ? 1 : 0.5
        if self.cursor.selected && !enabled {
            self.cursor.selected = false
        }

        playerComponent!.targetable = enabled
        firingComponent!.enabled = enabled
        selectableComponent!.enabled = enabled
        wanderingComponent!.enabled = enabled && (overrideWandering ?? true)
    }
}

// MARK: Fire Bullet

extension DroneNode {

    private func fireBullet(angle angle: CGFloat) {
        guard let world = world else {
            return
        }

        let speed: CGFloat = 125
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position

        bullet.damage = 1
        bullet.size = BaseTurretBulletArtist.bulletSize(.One)
        bullet.zRotation = angle
        bullet.z = Z.Below
        world << bullet
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

}
