//
//  DroneNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/22/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DroneNode: Node {
    static let DefaultSpeed: CGFloat = 30
    var cursor = CursorNode()
    var sprite = SKSpriteNode(id: .Drone(upgrade: .One))
    var placeholder = SKSpriteNode(id: .Drone(upgrade: .One))

    override var position: CGPoint {
        didSet {
            wanderingComponent?.centeredAround = position
        }
    }

    required init() {
        super.init()
        size = sprite.size

        placeholder.alpha = 0.5
        placeholder.hidden = false

        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 10
        addComponent(wanderingComponent)

        let targetingComponent = TargetingComponent()
        targetingComponent.reallySmart = true
        targetingComponent.sweepAngle = nil
        targetingComponent.radius = 100
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
        draggingComponent.onDragMove { isMoving in
            self.alpha = isMoving ? 0.5 : 1
            if self.cursor.selected && isMoving {
                self.cursor.selected = false
            }

            firingComponent.enabled = !isMoving
            selectableComponent.enabled = !isMoving
            wanderingComponent.enabled = !isMoving

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
