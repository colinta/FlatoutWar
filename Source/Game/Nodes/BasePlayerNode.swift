////
///  BasePlayerNode.swift
//

fileprivate let ForceFireDuration: CGFloat = 0.3
fileprivate let ForceFireDamageFactor: Float = 0.667
fileprivate let DefaultCooldown: CGFloat = 0.35
fileprivate let ForceFireCooldown: CGFloat = 0.12
fileprivate let ForceFireBurnoutUp: CGFloat = 6
fileprivate let ForceFireBurnoutDown: CGFloat = 4

class BasePlayerNode: Node {
    var forceFireEnabled: Bool?
    var forceFireBurnout = false
    var forceResourceEnabled = true {
        didSet { touchResourceComponent.enabled = forceResourceEnabled }
    }

    fileprivate var hurtSound = OpenALManager.sharedInstance().buffer(fromFile: "killed.caf")
    fileprivate var shootSound = OpenALManager.sharedInstance().buffer(fromFile: "short.caf")

    fileprivate var resourceLocation: CGPoint?
    fileprivate let resourceLine = SKSpriteNode()
    fileprivate var resourceLock: CGPoint?
    fileprivate var touchAimingComponent = TouchableComponent()
    fileprivate var touchResourceComponent = TouchableComponent()

    var turret: Turret = SimpleTurret() {
        didSet {
            radarNode.textureId(turret.radarId(upgrade: radarUpgrade))
            turretNode.textureId(turret.spriteId(bulletUpgrade: bulletUpgrade, turretUpgrade: turretUpgrade))
            targetingComponent?.enabled = turret.autoFireEnabled
            targetingComponent?.reallySmart = turret.reallySmart
        }
    }

    var rotateUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var bulletUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var radarUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var turretUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    fileprivate func updateUpgrades() {
        baseNode.textureId(.Base(rotateUpgrade: rotateUpgrade, bulletUpgrade: bulletUpgrade, health: healthComponent?.healthInt ?? 100))
        rotateToComponent?.maxAngularSpeed = rotateUpgrade.baseAngularSpeed
        rotateToComponent?.angularAccel = rotateUpgrade.baseAngularAccel
        radarNode.textureId(turret.radarId(upgrade: radarUpgrade))
        turretNode.textureId(turret.spriteId(bulletUpgrade: bulletUpgrade, turretUpgrade: turretUpgrade))
        firingComponent?.cooldown = turretUpgrade.baseCooldown
    }

    let radarNode = SKSpriteNode()
    let baseNode = SKSpriteNode()
    let turretNode = SKSpriteNode()
    let lightNode: SKLightNode

    let forceFirePercent = PercentBar()
    fileprivate var forceFireCooldown: CGFloat {
        return forceFireBurnout ? DefaultCooldown : ForceFireCooldown
    }

    override func reset() {
        super.reset()
    }

    required init() {
        lightNode = SKLightNode.defaultLight()
        super.init()

        size = CGSize(40)

        // self << lightNode

        radarNode.textureId(turret.radarId(upgrade: radarUpgrade))
        radarNode.anchorPoint = CGPoint(0, 0.5)
        radarNode.z = .BelowPlayer
        self << radarNode

        baseNode.textureId(.Base(rotateUpgrade: rotateUpgrade, bulletUpgrade: bulletUpgrade, health: 100))
        baseNode.z = .Player
        self << baseNode

        turretNode.textureId(turret.spriteId(bulletUpgrade: bulletUpgrade, turretUpgrade: turretUpgrade))
        turretNode.z = .AbovePlayer
        self << turretNode

        forceFirePercent.style = .Heat
        forceFirePercent.position = CGPoint(x: 25)
        forceFirePercent.complete = 0
        self << forceFirePercent

        resourceLine.isHidden = true
        resourceLine.z = .BelowPlayer
        resourceLine.anchorPoint = CGPoint(0, 0.5)
        resourceLine.alpha = 0.5
        self << resourceLine

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = baseNode
        addComponent(playerComponent)

        let healthComponent = HealthComponent(health: 100)
        healthComponent.onHurt { amount in
            self.onHurt()
            self.baseNode.textureId(.Base(rotateUpgrade: .False, bulletUpgrade: .False, health: healthComponent.healthInt))
        }
        addComponent(healthComponent)

        touchAimingComponent.on(.Tapped, onTouchAimingTapped)
        touchAimingComponent.onDragged(onDraggedAiming)
        addComponent(touchAimingComponent)

        touchResourceComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Circle)
        touchResourceComponent.on(.DragBegan, onDragResourceBegan)
        touchResourceComponent.on(.DragEnded, onDragResourceEnded)
        touchResourceComponent.onDragged(onDraggedResource)
        addComponent(touchResourceComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = baseNode
        rotateToComponent.maxAngularSpeed = rotateUpgrade.baseAngularSpeed
        rotateToComponent.angularAccel = rotateUpgrade.baseAngularAccel
        addComponent(rotateToComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.sweepAngle = radarUpgrade.baseSweepAngle
        targetingComponent.radius = radarUpgrade.baseRadarRadius
        targetingComponent.turret = baseNode
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.turret = baseNode
        firingComponent.cooldown = turretUpgrade.baseCooldown
        firingComponent.onFire { angle in
            self.fireBullet(angle: angle)
        }
        addComponent(firingComponent)
    }

    required init?(coder: NSCoder) {
        lightNode = SKLightNode.defaultLight()
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    func onHurt() {
        _ = world?.channel?.play(hurtSound)
    }

    func disableTouchForUI() {
        touchAimingComponent.enabled = false
        touchResourceComponent.enabled = false
    }

    override func update(_ dt: CGFloat) {
        let forceFire: Bool
        if let forceFireEnabled = self.forceFireEnabled {
            forceFire = forceFireEnabled
        }
        else if touchAimingComponent.touchedFor > 0 && turret.rapidFireEnabled {
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
        else if forceFirePercent.complete > 0 {
            forceFirePercent.complete -= dt / ForceFireBurnoutDown
            if forceFirePercent.complete == 0 {
                forceFireBurnout = false
            }
        }

        if let resourceLocation = resourceLocation {
            checkForResource(at: resourceLocation)
        }

        firingComponent?.forceFire = forceFire
        firingComponent?.cooldown = (forceFire ? forceFireCooldown : DefaultCooldown)

        if let firingAngle = firingComponent?.angle,
            forceFireEnabled != true
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
        guard let world = world else {
            return
        }

        let velocity: CGFloat = turretUpgrade.baseBulletSpeed
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

        bullet.damage = turretUpgrade.baseBulletDamage
        bullet.size = BulletArtist.bulletSize(upgrade: .False)
        bullet.zRotation = angle
        bullet.z = Z.Below
        bullet.damage *= damageFactor
        ((parent as? Node) ?? world) << bullet

        _ = world.channel?.play(shootSound)
    }

}

// MARK: Touch events

extension BasePlayerNode {

    override func touchableComponentFor(_ location: CGPoint) -> TouchableComponent {
        if location.lengthWithin(self.radius + 10) {
            return touchResourceComponent
        }
        return touchAimingComponent
    }

    func onTouchAimingTapped(at location: CGPoint) {
        targetingComponent?.currentTarget = nil
        startRotatingTo(angle: location.angle)
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        let angle = prevLocation.angleTo(location, around: position)
        let destAngle = rotateToComponent?.destAngle ?? 0
        startRotatingTo(angle: destAngle + angle)
    }

    func onDragResourceBegan(at location: CGPoint) {
        resourceLocation = location
        resourceLine.textureId(.None)
        resourceLine.alpha = 0.5
        resourceLine.visible = true
        resourceLock = nil
    }

    func onDraggedResource(from prevLocation: CGPoint, to location: CGPoint) {
        checkForResource(at: location)
    }

    func onDragResourceEnded(at location: CGPoint) {
        resourceLocation = nil
        resourceLine.visible = false
    }

    func checkForResource(at location: CGPoint) {
        if let world = world,
            let level = world as? ResourceWorld,
            resourceLock == nil
        {
            let dragLocation = world.convertPosition(self) + location
            for node in world.children {
                if let resourceNode = node as? ResourceNode,
                    !resourceNode.locked,
                    dragLocation.distanceTo(resourceNode.position, within: resourceNode.radius)
                {
                    level.playerFoundResource(node: resourceNode)
                    resourceLock = convertPosition(resourceNode)
                    break
                }
            }
        }

        let resourcePoint: CGPoint
        if let resourceLock = resourceLock {
            resourcePoint = resourceLock
            resourceLine.alpha = 1
        }
        else {
            resourcePoint = location
        }
        resourceLocation = resourcePoint
        resourceLine.textureId(.ResourceLine(length: resourcePoint.length))
        resourceLine.zRotation = resourcePoint.angle
    }

    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(_ angle: CGFloat) {
        baseNode.zRotation = angle
        radarNode.zRotation = angle
        turretNode.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }

}

extension HasUpgrade {
    var baseSweepAngle: CGFloat {
        switch self {
        case .False:   return 30.degrees
        case .True:  return 45.degrees
        }
    }

    var baseRadarRadius: CGFloat {
        switch self {
        case .False:   return 300
        case .True:   return 340
        }
    }

    var baseAngularSpeed: CGFloat {
        switch self {
            case .False: return 4
            case .True: return 10
        }
    }

    var baseAngularAccel: CGFloat? {
        switch self {
            case .False: return 3
            case .True: return 12
        }
    }

    var baseBulletDamage: Float {
        switch self {
            case .False: return 1
            case .True: return 1.25
        }
    }

    var baseCooldown: CGFloat {
        switch self {
            case .False: return 0.35
            case .True: return 0.35
        }
    }

    var baseBulletSpeed: CGFloat {
        switch self {
            case .False: return 125
            case .True: return 175
        }
    }
}
