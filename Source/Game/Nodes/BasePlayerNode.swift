//
//  BasePlayerNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let forceFireCooldown = CGFloat(0.4)
private let forceFireDamageFactor = Float(0.667)
private let defaultCooldown = CGFloat(1)

class BasePlayerNode: Node {
    var radar: SKSpriteNode!
    var base: SKSpriteNode!
    var turret: SKSpriteNode!

    override func reset() {
        super.reset()
    }

    required init() {
        super.init()

        size = CGSize(r: 20)

        let touchableComponent = TouchableComponent()
        touchableComponent.on(.Tapped, onTouchTapped)
        touchableComponent.onDragged(onTouchDragged)
        addComponent(touchableComponent)

        let healthComponent = HealthComponent(health: 100)
        healthComponent.onHurt { amount in
            self.base.texture = SKTexture.id(.Base(upgrade: .One, health: healthComponent.healthPercent))
        }
        addComponent(healthComponent)

        let playerComponent = PlayerComponent()
        addComponent(playerComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = base
        addComponent(rotateToComponent)

        let targetingComponent = TargetingComponent()
        targetingComponent.sweepAngle = 30.degrees
        targetingComponent.radius = 300
        targetingComponent.turret = base
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.cooldown = 0.35
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        radar = coder.decode("radar")
        base = coder.decode("base")
        turret = coder.decode("turret")
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func populate() {
        radar = SKSpriteNode(id: .Radar(upgrade: .One))
        radar.anchorPoint = CGPoint(0, 0.5)
        radar.zPosition = Node.Z.Bottom.rawValue
        self << radar

        base = SKSpriteNode(id: .Base(upgrade: .One, health: 1))
        base.zPosition = Node.Z.Default.rawValue
        self << base

        turret = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
        turret.zPosition = Node.Z.Above.rawValue
        self << turret
    }

    override func update(dt: CGFloat) {
        if let firingAngle = firingComponent?.angle,
            isTouching = touchableComponent?.isTouching
            where !isTouching
        {
            turret.zRotation = firingAngle
        }
        else if let currentAngle = rotateToComponent?.currentAngle {
            turret.zRotation = currentAngle
        }

        if let destAngle = rotateToComponent?.destAngle {
            radar.zRotation = destAngle
        }
    }

}

// MARK: Fire Bullet

extension BasePlayerNode {

    private func fireBullet(angle angle: CGFloat) {
        guard let world = world else {
            return
        }

        let velocity: CGFloat = 125
        let style: BulletNode.Style
        if firingComponent?.forceFire ?? false {
            style = .Fast
        }
        else {
            style = .Slow
        }
        let bullet = BulletNode(velocity: CGPoint(r: velocity, a: angle), style: style)
        bullet.position = self.position

        bullet.damage = 1
        bullet.size = BaseTurretBulletArtist.bulletSize(.One)
        bullet.zRotation = angle
        bullet.z = Z.Below
        if firingComponent!.forceFire {
            bullet.damage *= forceFireDamageFactor
        }
        world << bullet
    }

}

// MARK: Touch events

extension BasePlayerNode {

    func onTouchTapped(location: CGPoint) {
        if !location.lengthWithin(self.radius) {
            startRotatingTo(location.angle)
        }
    }

    func onTouchDragged(prevLocation: CGPoint, location: CGPoint) {
        let angle = prevLocation.angleTo(location, around: position)
        let destAngle = rotateToComponent?.destAngle ?? 0
        startRotatingTo(destAngle + angle)
    }

    private func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.destAngle = angle
    }

}
