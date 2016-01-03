//
//  BasePlayerNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let forceFireDuration: CGFloat = 0.3
private let forceFireDamageFactor: Float = 0.667
private let defaultCooldown: CGFloat = 0.35
private let forceFireCooldown: CGFloat = 0.14

class BasePlayerNode: Node {
    var overrideForceFire: Bool?

    var radar: SKSpriteNode!
    var base: SKSpriteNode!
    var turret: SKSpriteNode!

    override func reset() {
        super.reset()
    }

    required init() {
        super.init()

        size = CGSize(40)

        let playerComponent = PlayerComponent()
        addComponent(playerComponent)

        let healthComponent = HealthComponent(health: 100)
        healthComponent.onHurt { amount in
            self.base.textureId(.Base(upgrade: .One, health: healthComponent.healthInt))
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.on(.Tapped, onTouchTapped)
        touchableComponent.onDragged(onTouchDragged)
        addComponent(touchableComponent)

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
        firingComponent.turret = base
        firingComponent.cooldown = defaultCooldown
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
        radar.zPosition = Z.Bottom.rawValue
        self << radar

        base = SKSpriteNode(id: .Base(upgrade: .One, health: 100))
        base.zPosition = Z.Default.rawValue
        self << base

        turret = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
        turret.zPosition = Z.Above.rawValue
        self << turret
    }

    override func update(dt: CGFloat) {
        let forceFire: Bool
        if let overrideForceFire = self.overrideForceFire {
            forceFire = overrideForceFire
        }
        else if let touchedFor = touchableComponent?.touchedFor where touchedFor >= forceFireDuration {
            forceFire = true
        }
        else {
            forceFire = false
        }
        firingComponent?.forceFire = forceFire
        firingComponent?.cooldown = (forceFire ? forceFireCooldown : defaultCooldown)

        if let firingAngle = firingComponent?.angle,
            isTouching = touchableComponent?.isTouching
            where !isTouching
        {
            turret.zRotation = firingAngle
        }
        else {
            turret.zRotation = zRotation
        }

        if let firingAngle = firingComponent?.angle,
            isTouching = touchableComponent?.isTouching
            where !isTouching
        {
            turret.zRotation = firingAngle
        }
        else if let currentAngle = rotateToComponent?.currentAngle {
            turret.zRotation = currentAngle
        }

        if let target = rotateToComponent?.destAngle {
            radar.zRotation = target
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

    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(angle: CGFloat) {
        base.zRotation = angle
        radar.zRotation = angle
        turret.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }

}
