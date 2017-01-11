////
///  BasePlayerNode.swift
//

private let ForceFireDamageFactor: Float = 0.667
private let DefaultCooldown: CGFloat = 0.35
private let ForceFireCooldown: CGFloat = 0.12
private let ForceFireWarmup: CGFloat = 0.4


class BasePlayerNode: Node {
    var movementUpgrade: HasUpgrade = .False { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .False { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var radarUpgrade: HasUpgrade = .False { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }

    fileprivate let touchAimingComponent = TouchableComponent()

    fileprivate func updateBaseSprite() {
        baseSprite.textureId(.Base(movementUpgrade: movementUpgrade, bulletUpgrade: bulletUpgrade, radarUpgrade: radarUpgrade, health: healthComponent?.healthInt ?? 100))
    }
    fileprivate func updateRadarSprite() {
        let isSelected = selectableComponent?.selected == true
        radarSprite.alpha = isSelected ? 1 : 0.75
        if forceFireActive {
            radarSprite.textureId(.ColorLine(length: radarUpgrade.baseRadarRadius + 25, color: radarUpgrade.baseRadarColor))
        }
        else {
            radarSprite.textureId(.BaseRadar(upgrade: radarUpgrade, isSelected: isSelected))
        }
    }
    fileprivate func updateUpgrades() {
        turretSprite.textureId(.BaseSingleTurret(bulletUpgrade: bulletUpgrade))
        updateBaseSprite()
        updateRadarSprite()

        rotateToComponent?.maxAngularSpeed = movementUpgrade.baseAngularSpeed
        rotateToComponent?.angularAccel = movementUpgrade.baseAngularAccel

        firingComponent?.targetsPreemptively = radarUpgrade.targetsPreemptively
        firingComponent?.damage = calculateBulletDamage()

        enemyTargetingComponent?.sweepAngle = radarUpgrade.baseSweepAngle
        enemyTargetingComponent?.radius = radarUpgrade.baseRadarRadius

        size = CGSize(40)
    }

    var forceFireEnabled: Bool?
    var forceFireActive: Bool = false {
        didSet {
            if forceFireActive != oldValue {
                updateRadarSprite()
            }
        }
    }

    let radarSprite = SKSpriteNode()
    let baseSprite = SKSpriteNode()
    let turretSprite = SKSpriteNode()
    let lightNode: SKLightNode

    override func clone() -> Node {
        let node = super.clone() as! BasePlayerNode
        node.movementUpgrade = movementUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    required init() {
        lightNode = SKLightNode.defaultLight()
        super.init()

        // self << lightNode

        radarSprite.anchorPoint = CGPoint(0, 0.5)
        radarSprite.z = .BelowPlayer
        self << radarSprite

        baseSprite.z = .Player
        self << baseSprite

        turretSprite.z = .AbovePlayer
        self << turretSprite

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = baseSprite
        addComponent(playerComponent)

        let healthComponent = HealthComponent(health: 100)
        healthComponent.onHurt { _ in
            self.onHurt()
        }
        addComponent(healthComponent)

        touchAimingComponent.on(.Tapped, onTouchAimingTapped)
        touchAimingComponent.onDragged(onDraggedAiming)
        addComponent(touchAimingComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.onSelected { selected in
            self.updateRadarSprite()
        }
        addComponent(selectableComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = baseSprite
        addComponent(rotateToComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.turret = baseSprite
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.turret = baseSprite
        firingComponent.cooldown = DefaultCooldown
        firingComponent.onFireAngle(self.fireBullet)
        addComponent(firingComponent)

        updateUpgrades()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func onHurt() {
        _ = world?.channel?.play(Sound.PlayerHurt)
        updateBaseSprite()
    }

    func disableTouchForUI() {
        touchAimingComponent.enabled = false
    }

    override func update(_ dt: CGFloat) {
        if let forceFireEnabled = self.forceFireEnabled {
            forceFireActive = forceFireEnabled
        }
        else {
            forceFireActive = touchAimingComponent.touchedFor > ForceFireWarmup
        }

        firingComponent?.forceFire = forceFireActive
        firingComponent?.cooldown = (forceFireActive ? ForceFireCooldown : DefaultCooldown)

        if rotateToComponent?.target != nil, let currentAngle = rotateToComponent?.currentAngle {
            turretSprite.zRotation = currentAngle
        }
        else if let firingAngle = firingComponent?.angle,
            forceFireEnabled != true
        {
            turretSprite.zRotation = firingAngle
        }

        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }
    }

}

// MARK: Aiming helpers

extension BasePlayerNode {

    func aimAt(node: Node, location: CGPoint? = nil) {
        let location = self.convertPosition(node) + (location ?? .zero)
        aimAt(location: location)
    }

    func aimAt(location: CGPoint) {
        aimAt(angle: location.angle)
    }

    func aimAt(angle: CGFloat) {
        self.rotateToComponent?.target = angle
    }

}

// MARK: Fire Bullet

extension BasePlayerNode {

    fileprivate func fireBullet(angle: CGFloat) {
        guard let world = world else { return }

        let velocity: CGFloat = bulletUpgrade.baseBulletSpeed ± rand(5)
        let style: BulletNode.Style
        if firingComponent?.forceFire == true {
            style = .Fast
        }
        else {
            style = .Slow
        }

        let bullet = BulletNode(velocity: CGPoint(r: velocity, a: angle), style: style)
        bullet.position = self.position
        bullet.timeRate = self.timeRate

        bullet.size = BulletArtist.bulletSize(upgrade: .False)
        bullet.zRotation = angle
        bullet.damage = calculateBulletDamage(random: true)
        firingComponent?.damage = calculateBulletDamage()
        (parentNode ?? world) << bullet

        _ = world.channel?.play(Sound.PlayerShoot)
    }

    fileprivate func calculateBulletDamage(random: Bool = false) -> Float {
        if firingComponent?.forceFire == true {
            return bulletUpgrade.baseBulletDamage * ForceFireDamageFactor + (random ? 0 : rand(weighted: 0.25))
        }
        else {
            return bulletUpgrade.baseBulletDamage + (random ? 0 : rand(weighted: 0.5))
        }
    }

}

// MARK: Touch events

extension BasePlayerNode {

    func onTouchAimingTapped(at location: CGPoint) {
        enemyTargetingComponent?.currentTarget = nil
        startRotatingTo(angle: location.angle)
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        let angle = prevLocation.angleTo(location, around: position)
        let destAngle = rotateToComponent?.destAngle ?? rotateToComponent?.currentAngle ?? baseSprite.zRotation
        startRotatingTo(angle: destAngle + angle)
    }

    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(_ angle: CGFloat) {
        baseSprite.zRotation = angle
        radarSprite.zRotation = angle
        turretSprite.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }

}
