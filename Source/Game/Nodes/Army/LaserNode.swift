////
///  LaserNode.swift
//

private let startingHealth: Float = 60

class LaserNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .False { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .False { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var movementUpgrade: HasUpgrade = .False { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }

    let armyComponent = SelectableArmyComponent()

    fileprivate func updateTurretSprite() {
        turretSprite.textureId(.LaserTurret(upgrade: bulletUpgrade, isFiring: isFiring))
    }
    fileprivate func updateRadarSprite() {
        radarSprite.textureId(.LaserRadar(upgrade: radarUpgrade, isSelected: armyComponent.isSelected))
    }
    fileprivate func updateUpgrades() {
        baseSprite.textureId(.LaserNode(upgrade: movementUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.LaserNode(upgrade: movementUpgrade, health: 100))
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
    let placeholder = SKSpriteNode()
    let forceFirePercent = PercentBar()

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

        self << placeholder
        placeholder.alpha = 0.5
        placeholder.isHidden = true

        radarSprite.position = CGPoint(x: -5)
        radarSprite.anchorPoint = CGPoint(0, 0.5)

        beamSprite.position = CGPoint(x: 5)
        beamSprite.anchorPoint = CGPoint(0, 0.5)

        baseSprite.z = .Player
        radarSprite.z = .BelowPlayer
        turretSprite.z = .AbovePlayer
        beamSprite.z = Z.below(.AbovePlayer)

        self << baseSprite
        self << radarSprite
        self << turretSprite
        self << beamSprite

        forceFirePercent.style = .Heat
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

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.LaserNode(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Circle)
        touchableComponent.on(.DragBeganOutside, onDraggingOutside)
        touchableComponent.on(.DragEnded, onDraggingEnded)
        touchableComponent.onDragged(onDraggedAiming)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isSelected = $0 }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        touchableComponent.on(.DragBeganInside, draggableComponent.draggingBegan)
        touchableComponent.on(.DragEnded, draggableComponent.draggingEnded)
        touchableComponent.onDragged(draggableComponent.draggingMoved)

        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

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
            let node = ShrapnelNode(type: .FillColorBox(size: CGSize(1), color: color), size: .Actual)
            node.setupAround(node: target)
            parent! << node

            let width = length - beamSprite.position.x - target.radius
            beamSprite.textureId(.FillColorBox(size: CGSize(width, 1), color: color))
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

    override func rotateTo(_ angle: CGFloat) {
        baseSprite.zRotation = angle
        radarSprite.zRotation = angle
        turretSprite.zRotation = angle
        rotateToComponent?.target = nil
    }
}
