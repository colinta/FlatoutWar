////
///  TurretNode.swift
//

private let startingHealth: Float = 50

class TurretNode: Node {
    var radarUpgrade: HasUpgrade = .False {
        didSet {
            updateUpgrades()
        }
    }
    var upgrade: HasUpgrade = .False {
        didSet {
            updateUpgrades()
        }
    }
    fileprivate func updateUpgrades() {
        radarNode.textureId(.TurretRadar(upgrade: radarUpgrade))
        targetingComponent?.sweepAngle = radarUpgrade.turretSweepAngle
        targetingComponent?.radius = radarUpgrade.turretRadarRadius
        baseNode.textureId(.Turret(upgrade: upgrade, health: healthComponent?.healthInt ?? 100))
        targetingComponent?.bulletSpeed = upgrade.turretBulletSpeed
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
        radarNode.textureId(.TurretRadar(upgrade: radarUpgrade))

        self << baseNode
        self << cursor
        self << radarNode

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = baseNode
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.sweepAngle = radarUpgrade.turretSweepAngle
        targetingComponent.radius = radarUpgrade.turretRadarRadius
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

            self.world?.timeline.after(time: 20) {
                healthComponent.startingHealth = startingHealth
                self.baseNode.textureId(.Turret(upgrade: self.upgrade, health: healthComponent.healthInt))
                self.turretEnabled(isMoving: false)
            }
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Circle)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

}

extension TurretNode {

    func turretEnabled(isMoving: Bool) {
        let died = healthComponent!.died
        self.selectableComponent!.enabled = !died
        self.touchableComponent!.enabled = !died

        let enabled = !isMoving && !died
        self.alpha = died ? 0.5 : 0

        self.alpha = enabled ? 1 : 0.5
        if self.cursor.selected && !enabled {
            self.cursor.selected = false
        }

        playerComponent!.intersectable = enabled
        firingComponent!.enabled = enabled
        selectableComponent!.enabled = enabled
    }
}

// MARK: Fire Bullet

extension TurretNode {

    fileprivate func fireBullet(angle: CGFloat) {
        guard let world = world else {
            return
        }

        let speed: CGFloat = upgrade.turretBulletSpeed
        let bullet = BulletNode(velocity: CGPoint(r: speed, a: angle), style: .Slow)
        bullet.position = self.position

        bullet.damage = upgrade.turretBulletDamage
        bullet.size = BulletArtist.bulletSize(upgrade: .False)
        bullet.zRotation = angle
        bullet.z = Z.Below
        ((parent as? Node) ?? world) << bullet
    }

}

// MARK: Touch events

extension TurretNode {

    func onSelected(_ selected: Bool) {
        cursor.selected = selected
    }

}

extension HasUpgrade {
    var turretSweepAngle: CGFloat {
        switch self {
        case .False:   return 25.degrees
        case .True:  return 40.degrees
        }
    }

    var turretRadarRadius: CGFloat {
        switch self {
        case .False:   return 200
        case .True:  return 230
        }
    }

    var turretBulletDamage: Float {
        switch self {
        case .False: return 1.1
        case .True: return 1.3
        }
    }

    var turretCooldown: CGFloat {
        switch self {
        case .False: return 0.4
        case .True: return 0.4
        }
    }

    var turretAngularSpeed: CGFloat {
        switch self {
        case .False: return 3
        case .True: return 6
        }
    }

    var turretAngularAccel: CGFloat? {
        switch self {
        case .False: return 2
        case .True: return 8
        }
    }

    var turretBulletSpeed: CGFloat {
        switch self {
        case .False: return 115
        case .True: return 140
        }
    }

}
