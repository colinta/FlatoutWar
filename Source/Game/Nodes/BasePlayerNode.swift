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
private let ForceFireCooldown: CGFloat = 0.12
private let ForceFireBurnoutUp: CGFloat = 6
private let ForceFireBurnoutDown: CGFloat = 4

class BasePlayerNode: Node {
    var forceFireEnabled: Bool?
    var forceFireBurnout = false
    var turret: Turret = SimpleTurret() {
        didSet {
            radarNode.textureId(turret.radarId(upgrade: radarUpgrade))
            turretNode.textureId(turret.spriteId(upgrade: turretUpgrade))
            targetingComponent?.enabled = turret.autoFireEnabled
        }
    }

    var baseUpgrade: FiveUpgrades = .One {
        didSet {
            baseNode.textureId(.Base(upgrade: baseUpgrade, health: healthComponent?.healthInt ?? 100))
            rotateToComponent?.maxAngularSpeed = baseUpgrade.baseAngularSpeed
            rotateToComponent?.angularAccel = baseUpgrade.baseAngularAccel
        }
    }
    var radarUpgrade: FiveUpgrades = .One {
        didSet {
            radarNode.textureId(turret.radarId(upgrade: radarUpgrade))
        }
    }
    var turretUpgrade: FiveUpgrades = .One {
        didSet {
            turretNode.textureId(turret.spriteId(upgrade: turretUpgrade))
            firingComponent?.cooldown = turretUpgrade.turretCooldown
        }
    }

    var radarNode = SKSpriteNode()
    var baseNode = SKSpriteNode()
    var turretNode = SKSpriteNode()
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

        radarNode.textureId(turret.radarId(upgrade: radarUpgrade))
        radarNode.anchorPoint = CGPoint(0, 0.5)
        radarNode.z = .Radar
        self << radarNode

        baseNode.textureId(.Base(upgrade: radarUpgrade, health: 100))
        baseNode.z = .Player
        self << baseNode

        turretNode.textureId(turret.spriteId(upgrade: turretUpgrade))
        turretNode.z = .Turret
        self << turretNode

        forceFirePercent.style = .Heat
        forceFirePercent.position = CGPoint(x: 25)
        forceFirePercent.complete = 0
        self << forceFirePercent

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = baseNode
        addComponent(playerComponent)

        let healthComponent = HealthComponent(health: 100)
        healthComponent.onHurt { amount in
            self.baseNode.textureId(.Base(upgrade: .One, health: healthComponent.healthInt))
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.on(.Tapped, onTouchTapped)
        touchableComponent.onDragged(onTouchDragged)
        addComponent(touchableComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = baseNode
        rotateToComponent.maxAngularSpeed = baseUpgrade.baseAngularSpeed
        rotateToComponent.angularAccel = baseUpgrade.baseAngularAccel
        addComponent(rotateToComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.sweepAngle = radarUpgrade.radarSweepAngle
        targetingComponent.radius = radarUpgrade.radarRadius
        targetingComponent.turret = baseNode
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.turret = baseNode
        firingComponent.cooldown = turretUpgrade.turretCooldown
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        radarNode = coder.decode("radar")
        baseNode = coder.decode("base")
        turretNode = coder.decode("turret")
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        let forceFire: Bool
        if let forceFireEnabled = self.forceFireEnabled {
            forceFire = forceFireEnabled
        }
        else if let touchedFor = touchableComponent?.touchedFor
        where touchedFor > 0 && turret.rapidFireEnabled {
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
            where !isTouching || forceFireEnabled == false
        {
            turretNode.zRotation = firingAngle
        }
        else if let currentAngle = rotateToComponent?.currentAngle {
            turretNode.zRotation = currentAngle
        }

        if let angle = rotateToComponent?.destAngle {
            radarNode.zRotation = angle
        }
    }

    override func applyUpgrade(upgradeType: UpgradeType) {
        switch upgradeType {
        case .Upgrade: baseUpgrade = (baseUpgrade + 1) ?? baseUpgrade
        case .RadarUpgrade: radarUpgrade = (radarUpgrade + 1) ?? radarUpgrade
        case .TurretUpgrade: turretUpgrade = (turretUpgrade + 1) ?? turretUpgrade
        // default: break
        }
    }

    override func availableUpgrades() -> [UpgradeInfo] {
        var upgrades: [UpgradeInfo] = []

        if let nextBaseUpgrade = baseUpgrade + 1 {
            let upgrade = BasePlayerRotatingDemoNode(baseUpgrade: nextBaseUpgrade, radarUpgrade: radarUpgrade, turretUpgrade: turretUpgrade)

            let cost: Int
            switch nextBaseUpgrade {
                case .Two: cost = 100
                case .Three: cost = 150
                case .Four: cost = 200
                case .Five: cost = 300
                default: cost = 0
            }

            upgrades << (upgradeNode: upgrade, cost: cost, upgradeType: .Upgrade)
        }

        if let nextRadarUpgrade = radarUpgrade + 1 {
            let upgrade = Node()
            upgrade << {
                let node = SKSpriteNode(id: .Base(upgrade: baseUpgrade, health: 100))
                node.z = .Default
                return node
            }()
            upgrade << {
                let node = SKSpriteNode(id: .BaseRadar(upgrade: nextRadarUpgrade))
                node.anchorPoint = CGPoint(0, 0.5)
                node.z = .Below
                return node
            }()
            upgrade << {
                let node = SKSpriteNode(id: .BaseSingleTurret(upgrade: turretUpgrade))
                node.z = .Above
                return node
            }()

            let cost: Int
            switch nextRadarUpgrade {
                case .Two: cost = 100
                case .Three: cost = 150
                case .Four: cost = 200
                case .Five: cost = 300
                default: cost = 0
            }

            upgrades << (upgradeNode: upgrade, cost: cost, upgradeType: .RadarUpgrade)
        }

        if let nextTurretUpgrade = turretUpgrade + 1 {
            let current = Node()
            current << {
                let node = SKSpriteNode(id: .Base(upgrade: baseUpgrade, health: 100))
                node.z = .Default
                return node
            }()
            current << {
                let node = SKSpriteNode(id: .BaseSingleTurret(upgrade: turretUpgrade))
                node.z = .Above
                return node
            }()

            let upgrade = BasePlayerFiringDemoNode(baseUpgrade: baseUpgrade, radarUpgrade: radarUpgrade, turretUpgrade: nextTurretUpgrade)

            let cost: Int
            switch nextTurretUpgrade {
                case .Two: cost = 100
                case .Three: cost = 150
                case .Four: cost = 200
                case .Five: cost = 300
                default: cost = 0
            }

            upgrades << (upgradeNode: upgrade, cost: cost, upgradeType: .TurretUpgrade)
        }

        return upgrades
    }

}

// MARK: public helpers

extension BasePlayerNode {

    func aimAt(node node: Node, location: CGPoint? = nil) {
        let location = self.convertPosition(node) + (location ?? .zero)
        aimAt(location: location)
    }

    func aimAt(location location: CGPoint) {
        aimAt(angle: location.angle)
    }

    func aimAt(angle angle: CGFloat) {
        self.rotateToComponent?.target = angle
    }

}

// MARK: Fire Bullet

extension BasePlayerNode {

    private func fireBullet(angle angle: CGFloat) {
        guard let world = world else {
            return
        }

        let velocity: CGFloat = radarUpgrade.radarBulletSpeed
        let style: BulletNode.Style
        var damageFactor: Float = 1
        if firingComponent?.forceFire ?? false {
            style = .Fast
            damageFactor = ForceFireDamageFactor
        }
        else {
            style = .Slow
        }
        let bullet = BulletNode(velocity: CGPoint(r: velocity, a: angle), style: style)
        bullet.position = self.position
        bullet.timeRate = self.timeRate

        bullet.damage = turretUpgrade.turretBulletDamage
        bullet.size = BaseTurretBulletArtist.bulletSize(.One)
        bullet.zRotation = angle
        bullet.z = Z.Below
        bullet.damage *= damageFactor
        world << bullet
    }

}

// MARK: Touch events

extension BasePlayerNode {

    func onTouchTapped(location: CGPoint) {
        if !location.lengthWithin(self.radius) {
            targetingComponent?.currentTarget = nil
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
        baseNode.zRotation = angle
        radarNode.zRotation = angle
        turretNode.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }

}

extension FiveUpgrades {

    var turretBulletDamage: Float {
        switch self {
            case .One: return 1
            case .Two: return 1.1
            case .Three: return 1.2
            case .Four: return 1.3
            case .Five: return 1.6
        }
    }

    var turretCooldown: CGFloat {
        switch self {
            case .One: return 0.35
            case .Two: return 0.35
            case .Three: return 0.35
            case .Four: return 0.35
            case .Five: return 0.35
        }
    }

    var baseAngularSpeed: CGFloat {
        switch self {
            case .One: return 4
            case .Two: return 6
            case .Three: return 8
            case .Four: return 10
            case .Five: return 16
        }
    }

    var baseAngularAccel: CGFloat? {
        switch self {
            case .One: return 3
            case .Two: return 6
            case .Three: return 9
            case .Four: return 12
            case .Five: return nil  // no 'warm up' acceleration
        }
    }

    var radarBulletSpeed: CGFloat {
        switch self {
            case .One: return 125
            case .Two: return 125
            case .Three: return 150
            case .Four: return 175
            case .Five: return 200
        }
    }
    var radarSweepAngle: CGFloat {
        switch self {
            case .One:   return 30.degrees
            case .Two:   return 35.degrees
            case .Three: return 35.degrees
            case .Four:  return 35.degrees
            case .Five:  return 45.degrees
        }
    }
    var radarRadius: CGFloat {
        switch self {
            case .One:   return 300
            case .Two:   return 315
            case .Three: return 315
            case .Four:  return 315
            case .Five:  return 340
        }
    }

}
