//
//  BasePlayerNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let ForceFireDuration: CGFloat = 0.3
private let ForceFireDamageFactor: Float = 0.667
private let DefaultCooldown: CGFloat = 0.35
private let ForceFireCooldown: CGFloat = 0.14
private let ForceFireBurnoutUp: CGFloat = 6
private let ForceFireBurnoutDown: CGFloat = 4

class BasePlayerNode: Node {
    var overrideForceFire: Bool?
    var forceFireBurnout = false

    var radar = SKSpriteNode()
    var base = SKSpriteNode()
    var turret = SKSpriteNode()
    let forceFirePercent = PercentBar()
    private var forceFireCooldown: CGFloat {
        return forceFireBurnout ? DefaultCooldown : ForceFireCooldown
    }

    override func reset() {
        super.reset()
    }

    required init() {
        super.init()

        size = CGSize(40)

        radar.textureId(.Radar(upgrade: .One))
        radar.anchorPoint = CGPoint(0, 0.5)
        radar.zPosition = Z.Bottom.rawValue
        self << radar

        base.zPosition = Z.Default.rawValue
        base.textureId(.Base(upgrade: .One, health: 100))
        self << base

        turret.zPosition = Z.Default.rawValue + 0.5
        turret.textureId(.BaseSingleTurret(upgrade: .One))
        self << turret

        forceFirePercent.style = .Heat
        forceFirePercent.position = CGPoint(x: 25)
        forceFirePercent.complete = 0
        self << forceFirePercent

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = base
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
        firingComponent.cooldown = DefaultCooldown
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

    override func update(dt: CGFloat) {
        let forceFire: Bool
        if let overrideForceFire = self.overrideForceFire {
            forceFire = overrideForceFire
        }
        else if let touchedFor = touchableComponent?.touchedFor
        where touchedFor >= ForceFireDuration {
            forceFire = true
        }
        else {
            forceFire = false
        }

        if forceFire && !forceFireBurnout {
            forceFirePercent.complete += dt / ForceFireBurnoutUp
            if forceFirePercent.complete == 1 {
                forceFireBurnout = true
            }
        }
        else {
            forceFirePercent.complete -= dt / ForceFireBurnoutDown
            if forceFirePercent.complete == 0 {
                forceFireBurnout = false
            }
        }

        firingComponent?.forceFire = forceFire
        firingComponent?.cooldown = (forceFire ? forceFireCooldown : DefaultCooldown)

        if let firingAngle = firingComponent?.angle,
            isTouching = touchableComponent?.isTouching
            where !isTouching || overrideForceFire == false
        {
            turret.zRotation = firingAngle
        }
        else if let currentAngle = rotateToComponent?.currentAngle {
            turret.zRotation = currentAngle
        }

        if let angle = rotateToComponent?.destAngle {
            radar.zRotation = angle
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
        if firingComponent!.forceFire && !forceFireBurnout {
            bullet.damage *= ForceFireDamageFactor
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
