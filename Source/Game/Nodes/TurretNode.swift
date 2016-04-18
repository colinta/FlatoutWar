//
//  TurretNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/17/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 50

class TurretNode: Node {
    var upgrade: FiveUpgrades = .One {
        didSet {
            baseNode.textureId(.Turret(upgrade: upgrade, health: healthComponent?.healthInt ?? 100))
            radarNode.textureId(.TurretRadar(upgrade: upgrade))
            targetingComponent?.sweepAngle = upgrade.turretSweepAngle
            targetingComponent?.radius = upgrade.turretRadarRadius
            targetingComponent?.bulletSpeed = upgrade.turretBulletSpeed
        }
    }

    var cursor = CursorNode()
    let radarNode = SKSpriteNode()
    var baseNode = SKSpriteNode()

    required init() {
        super.init()
        size = CGSize(25)

        baseNode.textureId(.Turret(upgrade: upgrade, health: 100))
        radarNode.position = CGPoint(x: -5)
        radarNode.anchorPoint = CGPoint(0, 0.5)
        radarNode.textureId(.TurretRadar(upgrade: upgrade))

        self << baseNode
        self << cursor
        self << radarNode

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = baseNode
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.sweepAngle = upgrade.turretSweepAngle
        targetingComponent.radius = upgrade.turretRadarRadius
        targetingComponent.bulletSpeed = upgrade.turretBulletSpeed
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.cooldown = 0.4
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.baseNode.textureId(.Turret(upgrade: self.upgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.turretEnabled(isMoving: false)

            self.world?.timeline.after(20) {
                healthComponent.startingHealth = startingHealth
                self.baseNode.textureId(.Turret(upgrade: self.upgrade, health: healthComponent.healthInt))
                self.turretEnabled(isMoving: false)
            }
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Circle)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func applyUpgrade(upgradeType: UpgradeType) {
        switch upgradeType {
        case .Upgrade: upgrade = (upgrade + 1) ?? upgrade
        default: break
        }
    }

    override func availableUpgrades() -> [UpgradeInfo] {
        var upgrades: [UpgradeInfo] = []

        if let nextTurretUpgrade = upgrade + 1 {
            let upgrade = Node()
            upgrade << SKSpriteNode(id: .Turret(upgrade: nextTurretUpgrade, health: 100))

            let cost: Int
            switch nextTurretUpgrade {
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

extension TurretNode {

    func turretEnabled(isMoving isMoving: Bool) {
        let died = healthComponent!.died
        self.selectableComponent!.enabled = !died
        self.touchableComponent!.enabled = !died

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
    }
}

// MARK: Fire Bullet

extension TurretNode {

    private func fireBullet(angle angle: CGFloat) {
        guard let world = world else {
            return
        }

        let speed: CGFloat = upgrade.turretBulletSpeed
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position

        bullet.damage = upgrade.turretBulletDamage
        bullet.size = BaseTurretBulletArtist.bulletSize(.One)
        bullet.zRotation = angle
        bullet.z = Z.Below
        ((parent as? Node) ?? world) << bullet
    }

}

// MARK: Touch events

extension TurretNode {

    func onSelected(selected: Bool) {
        cursor.selected = selected
    }

}

extension FiveUpgrades {

    var turretBulletDamage: Float {
        switch self {
            case .One: return 1.1
            case .Two: return 1.25
            case .Three: return 1.4
            case .Four: return 1.6
            case .Five: return 2
        }
    }

    var turretCooldown: CGFloat {
        switch self {
            case .One: return 0.4
            case .Two: return 0.4
            case .Three: return 0.4
            case .Four: return 0.4
            case .Five: return 0.4
        }
    }

    var turretAngularSpeed: CGFloat {
        switch self {
            case .One: return 3
            case .Two: return 5
            case .Three: return 7
            case .Four: return 9
            case .Five: return 15
        }
    }

    var turretAngularAccel: CGFloat? {
        switch self {
            case .One: return 2
            case .Two: return 5
            case .Three: return 8
            case .Four: return 11
            case .Five: return 15
        }
    }

    var turretBulletSpeed: CGFloat {
        switch self {
            case .One: return 115
            case .Two: return 115
            case .Three: return 140
            case .Four: return 165
            case .Five: return 190
        }
    }

    var turretSweepAngle: CGFloat {
        switch self {
            case .One:   return 25.degrees
            case .Two:   return 30.degrees
            case .Three: return 35.degrees
            case .Four:  return 40.degrees
            case .Five:  return 50.degrees
        }
    }

    var turretRadarRadius: CGFloat {
        switch self {
            case .One:   return 200
            case .Two:   return 215
            case .Three: return 215
            case .Four:  return 215
            case .Five:  return 240
        }
    }

}
