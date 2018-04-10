////
///  LaserNode.swift
//

private let StartingHealth: Float = 60

class LaserNode: Node {
    var radarUpgrade: HasUpgrade = .false { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .false { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var movementUpgrade: HasUpgrade = .false { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }

    let armyComponent = SelectableArmyComponent()

    fileprivate func updateTurretSprite() {
        turretSprite.textureId(.laserTurret(upgrade: bulletUpgrade, isFiring: isFiring))
    }
    fileprivate func updateRadarSprite() {
        radarSprite.textureId(.laserRadar(upgrade: radarUpgrade, isSelected: armyComponent.isCurrent))
    }
    fileprivate func updateUpgrades() {
        baseSprite.textureId(.laserNode(upgrade: movementUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder?.textureId(.laserNode(upgrade: movementUpgrade, health: 100))
        updateRadarSprite()
        updateTurretSprite()

        draggableComponent?.speed = movementUpgrade.laserMovementSpeed

        enemyTargetingComponent?.sweepWidth = radarUpgrade.laserSweepWidth
        enemyTargetingComponent?.radius = radarUpgrade.laserRadarRadius

        rotateToComponent?.maxAngularSpeed = movementUpgrade.laserAngularSpeed
        rotateToComponent?.angularAccel = movementUpgrade.laserAngularAccel

        size = CGSize(30)
    }

    let radarSprite = SKSpriteNode()
    let baseSprite = SKSpriteNode()
    let turretSprite = SKSpriteNode()
    let beamSprite = SKSpriteNode()
    let forceFirePercent = PercentBar()
    var placeholder: SKSpriteNode? { return draggableComponent?.placeholder as? SKSpriteNode }

    var isRotating = false
    var isFiring = false { didSet {
        if isFiring != oldValue {
            updateTurretSprite()
        }
    } }

    var shootingDuration: CGFloat = 0
    var cooldownDuration: CGFloat = 0

    required init() {
        super.init()

        radarSprite.position = CGPoint(x: -5)
        radarSprite.anchorPoint = CGPoint(0, 0.5)

        beamSprite.position = CGPoint(x: 5)
        beamSprite.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .player
        radarSprite.z = .belowPlayer
        turretSprite.z = .abovePlayer
        beamSprite.z = Z.zBelow(.abovePlayer)

        self << baseSprite
        self << radarSprite
        self << turretSprite
        self << beamSprite

        forceFirePercent.style = .heat
        forceFirePercent.position = CGPoint(x: -20)
        forceFirePercent.complete = 0
        self << forceFirePercent

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseSprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.turret = baseSprite
        addComponent(targetingComponent)

        let healthComponent = HealthComponent(health: StartingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.laserNode(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .circle)
        touchableComponent.on(.dragBeganOutside, onDraggingOutside)
        touchableComponent.on(.dragEnded, onDraggingEnded)
        touchableComponent.onDragged(onDraggedAiming)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isCurrentSelected = $0 }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        touchableComponent.on(.dragBeganInside, draggableComponent.draggingBegan)
        touchableComponent.on(.dragEnded, draggableComponent.draggingEnded)
        touchableComponent.onDragged(draggableComponent.draggingMoved)
        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        let placeholder = SKSpriteNode()
        draggableComponent.placeholder = placeholder
        self << placeholder

        let rotateToComponent = RotateToComponent()
        rotateToComponent.applyTo = baseSprite
        addComponent(rotateToComponent)

        let cursor = CursorNode()
        self << cursor

        armyComponent.cursorNode = cursor
        armyComponent.radarNode = radarSprite
        armyComponent.onUpdated { _ in self.updateRadarSprite() }
        addComponent(armyComponent)

        updateUpgrades()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func clone() -> Node {
        let node = super.clone() as! LaserNode
        node.movementUpgrade = movementUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }

        let angle: CGFloat
        let percent: CGFloat
        var firingInfo: (CGFloat, Node)?
        if cooldownDuration > 0 {
            angle = baseSprite.zRotation

            cooldownDuration -= dt
            if cooldownDuration <= 0 {
                cooldownDuration = 0
                percent = 0
            }
            else {
                percent = cooldownDuration / bulletUpgrade.laserBurnoutDown
            }
        }
        else {
            if !armyComponent.isMoving,
                let currentTarget = enemyTargetingComponent?.currentTarget,
                let currentPosition = enemyTargetingComponent?.firingPosition()
            {
                angle = currentPosition.angle
                firingInfo = (currentPosition.length, currentTarget)
                beamSprite.zRotation = angle

                let damage = bulletUpgrade.laserDamagePerSec * Float(dt)
                currentTarget.healthComponent?.inflict(damage: damage)

                shootingDuration += dt
            }
            else {
                angle = radarSprite.zRotation
                shootingDuration = max(shootingDuration - dt, 0)
            }

            if shootingDuration > bulletUpgrade.laserBurnoutUp {
                cooldownDuration = bulletUpgrade.laserBurnoutDown
                shootingDuration = 0
                percent = 1
            }
            else {
                percent = shootingDuration / bulletUpgrade.laserBurnoutUp
            }
        }
        let isFiring = firingInfo != nil
        self.isFiring = isFiring
        beamSprite.visible = isFiring
        if let (length, target) = firingInfo {
            let color = interpolateHex(rand(1), colors: (0x88E2FF, 0x7D9BFF))
            let node = ShrapnelNode(type: .fillColorBox(size: CGSize(1), color: color), size: .actual)
            node.setupAround(node: target)
            parent! << node

            let width = length - beamSprite.position.x - target.radius
            beamSprite.textureId(.fillColorBox(size: CGSize(width, 1), color: color))
        }
        forceFirePercent.complete = percent

        turretSprite.zRotation = angle
    }
}

// MARK: Touch events
extension LaserNode {
    func onDraggingOutside(at location: CGPoint) {
        isRotating = true
    }
    func onDraggingEnded(at location: CGPoint) {
        isRotating = false
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        guard isRotating else { return }

        let angle = prevLocation.angleTo(location, around: position)
        let destAngle = rotateToComponent?.destAngle ?? 0
        startRotatingTo(angle: destAngle + angle)
    }
}

// MARK: Rotation
extension LaserNode {
    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func setRotation(_ angle: CGFloat) {
        baseSprite.zRotation = angle
        radarSprite.zRotation = angle
        turretSprite.zRotation = angle
        rotateToComponent?.target = nil
    }
}
