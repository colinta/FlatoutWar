//
//  DroneNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/22/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DroneNode: Node {
    static let DefaultSpeed: CGFloat = 30
    var overrideWandering: Bool? {
        didSet {
            if let overrideWandering = overrideWandering, enabled = wanderingComponent?.enabled where enabled {
                wanderingComponent!.enabled = overrideWandering
            }
        }
    }

    var cursor = CursorNode()
    let radar1 = SKShapeNode()
    let radar2 = SKShapeNode()
    var sprite = SKSpriteNode(id: .Drone(upgrade: .One))
    var placeholder = SKSpriteNode(id: .Drone(upgrade: .One))

    override var position: CGPoint {
        didSet {
            wanderingComponent?.centeredAround = position
        }
    }

    required init() {
        super.init()
        size = CGSize(20)

        placeholder.alpha = 0.5
        placeholder.hidden = false

        // let playerComponent = PlayerComponent()
        // addComponent(playerComponent)

        // let healthComponent = HealthComponent(health: 100)
        // healthComponent.onHurt { amount in
        //     self.sprite.textureId(.Drone(upgrade: .One))
        // }
        // addComponent(healthComponent)

        let phaseComponent = PhaseComponent()
        phaseComponent.duration = 3
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
        targetingComponent.radius = 75
        targetingComponent.bulletSpeed = 125
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.cooldown = 0.3
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Square)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)

        let draggingComponent = DraggableComponent()
        draggingComponent.speed = DroneNode.DefaultSpeed
        draggingComponent.placeholder = placeholder
        draggingComponent.bindTo(touchableComponent: touchableComponent)
        draggingComponent.onDragging { isDragging in
            wanderingComponent.enabled = !isDragging
        }
        draggingComponent.onDragChange { isMoving in
            self.droneEnabled(!isMoving)
            self.world?.unselectNode(self)
        }
        addComponent(draggingComponent)
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

    override func populate() {
        self << sprite
        self << cursor
        self << placeholder
    }

    override func update(dt: CGFloat) {
        let phase = phaseComponent!.phase
        let radarRadius: CGFloat = targetingComponent!.radius!
        if phase < 0.9 {
            let path = CGPathCreateMutable()
            let easedPhase = easeOutExpo(time: interpolate(phase, from: (0.5, 0.9), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.6, 0.8), to: (0.25, 0))
            radar1.alpha = alpha
            CGPathAddEllipseInRect(path, nil, CGPointZero.rectWithSize(CGSize(r: radarRadius * easedPhase)))
            radar1.path = path
        }
        else {
            radar1.alpha = 0
        }

        if phase > 0.6 {
            let path = CGPathCreateMutable()
            let easedPhase = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
            let alpha = interpolate(phase, from: (0.8, 1.0), to: (0.25, 0))
            radar2.alpha = alpha
            CGPathAddEllipseInRect(path, nil, CGPointZero.rectWithSize(CGSize(r: radarRadius * easedPhase)))
            radar2.path = path
        }
        else {
            radar2.alpha = 0
        }
    }

}

extension DroneNode {
    func droneEnabled(enabled: Bool) {
        self.alpha = enabled ? 1 : 0.5
        if self.cursor.selected && !enabled {
            self.cursor.selected = false
        }

        firingComponent!.enabled = enabled
        selectableComponent!.enabled = enabled
        wanderingComponent!.enabled = enabled && (self.overrideWandering ?? true)
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
