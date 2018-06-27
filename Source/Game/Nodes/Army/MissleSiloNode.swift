////
///  MissleSiloNode.swift
//

private let StartingHealth: Float = 50

class MissleSiloNode: Node {
    var radarUpgrade: HasUpgrade = .false { didSet { if radarUpgrade != oldValue { updateUpgrades() } } }
    var bulletUpgrade: HasUpgrade = .false { didSet { if bulletUpgrade != oldValue { updateUpgrades() } } }
    var movementUpgrade: HasUpgrade = .false { didSet { if movementUpgrade != oldValue { updateUpgrades() } } }

    let armyComponent = SelectableArmyComponent()

    fileprivate func updateRadarSprite() {
        radarSprite.textureId(.missleSiloRadar(upgrade: radarUpgrade, isSelected: armyComponent.isCurrent))
    }
    fileprivate func updateUpgrades() {
        turretBox.textureId(.missleSiloBox(upgrade: bulletUpgrade))
        baseSprite.textureId(.missleSilo(upgrade: movementUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder?.textureId(.missleSilo(upgrade: movementUpgrade, health: 100))
        updateRadarSprite()

        draggableComponent?.speed = movementUpgrade.missleSiloMovementSpeed

        enemyTargetingComponent?.radius = radarUpgrade.missleSiloRadarRadius
        enemyTargetingComponent?.bulletSpeed = bulletUpgrade.missleSiloBulletSpeed

        firingComponent?.targetsPreemptively = true
        firingComponent?.damage = bulletUpgrade.missleSiloBulletDamage

        rotateToComponent?.maxAngularSpeed = movementUpgrade.missleSiloAngularSpeed
        rotateToComponent?.angularAccel = movementUpgrade.missleSiloAngularAccel

        size = CGSize(30)
    }

    fileprivate func updateMissleSprites() {
        var prevCount = missleSprites.count
        guard prevCount != missleCount else { return }

        for sprite in missleSprites {
            sprite.removeFromParent()
        }

        let dy: CGFloat = CGFloat(20 - 2) / CGFloat(maxMissleCount)
        var turretY: CGFloat = dy / 2 * CGFloat(maxMissleCount - 1)
        missleSprites = []
        for _ in 0..<missleCount {
            let missleSprite = SKSpriteNode(id: .missle)
            missleSprite.z = .abovePlayer
            missleSprite.position = CGPoint(y: turretY)
            turretNode << missleSprite
            missleSprites << missleSprite
            turretY -= dy

            prevCount -= 1
            if prevCount < 0 {
                let destScale = missleSprite.xScale
                missleSprite.setScale(0)
                missleSprite.run(
                    SKAction.scale(to: destScale, duration: 0.25)
                )
            }
        }

        firingComponent?.enabled = armyComponent.armyEnabled && missleCount > 0
    }

    let radarSprite = SKSpriteNode()
    let baseSprite = SKSpriteNode()
    let turretBox = SKSpriteNode()
    let turretNode = SKNode()
    var maxMissleCount: Int = 3
    private var missleCreationTimer: CGFloat = 0
    var missleCount: Int {
        didSet {
            updateMissleSprites()
        }
    }
    fileprivate var missleSprites: [SKSpriteNode] = []
    var placeholder: SKSpriteNode? { return draggableComponent?.placeholder as? SKSpriteNode }

    var isDragging = false
    var dragStart: CGPoint?

    required init() {
        missleCount = maxMissleCount
        super.init()

        baseSprite.z = .player
        radarSprite.z = .belowPlayer
        turretBox.z = .above

        self << baseSprite
        self << radarSprite
        turretBox.anchorPoint = CGPoint(x: 0.75, y: 0.5)
        self << turretBox
        self << turretNode

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseSprite
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.turret = radarSprite
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFireTarget(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: StartingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.missleSilo(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.armyComponent.isMoving = false
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .circle)
        touchableComponent.on(.dragBeganOutside, onDraggingBegan)
        touchableComponent.on(.dragEnded, onDraggingEnded)
        touchableComponent.onDragged(onDraggedAiming)
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { self.armyComponent.isCurrentSelected = ($0, $1) }
        addComponent(selectableComponent)

        let draggableComponent = DraggableComponent()
        touchableComponent.on(.dragBeganInside, draggableComponent.draggingBegan)
        touchableComponent.on(.dragEnded, draggableComponent.draggingEnded)
        touchableComponent.onDragged(draggableComponent.draggingMoved)
        draggableComponent.onDragChange { isMoving in
            self.armyComponent.isMoving = isMoving
            self.world?.unselectNode(self)
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
        armyComponent.onUpdated { armyEnabled in
            self.firingComponent?.enabled = armyEnabled && self.missleCount > 0
            self.updateRadarSprite()
        }
        armyComponent.radarNode = radarSprite
        addComponent(armyComponent)

        missleCreationTimer = movementUpgrade.missleSiloReloadTime
        updateUpgrades()
        updateMissleSprites()

        radarSprite.position = CGPoint(r: 100, a: rand(TAU))
        setRotation(radarSprite.position.angle)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func clone() -> Node {
        let node = super.clone() as! MissleSiloNode
        node.movementUpgrade = movementUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }

        let angle = baseSprite.zRotation
        turretBox.zRotation = angle
        turretNode.zRotation = firingComponent?.angle ?? angle

        if missleCount < maxMissleCount && armyComponent.armyEnabled {
            missleCreationTimer -= dt

            if missleCreationTimer <= 0 {
                missleCreationTimer = movementUpgrade.missleSiloReloadTime

                if missleCount == 0 {
                    firingComponent?.lastFiredCooldown = 0
                }

                missleCount += 1
                firingComponent?.cooldown = bulletUpgrade.missleSiloCooldown
            }
        }
    }
}

extension MissleSiloNode {
    fileprivate func fireBullet(target: Node) {
        guard let world = world else { return }

        let missleOffset: CGPoint
        if let sprite = missleSprites.last {
            missleOffset = convertPosition(sprite)
        }
        else {
            missleOffset = .zero
        }
        let bullet = MissleNode(
            damage: bulletUpgrade.missleSiloBulletDamage,
            speed: bulletUpgrade.missleSiloBulletSpeed,
            radius: bulletUpgrade.missleSiloSplashRadius,
            target: target)
        bullet.position = position + missleOffset
        bullet.zRotation = zRotation
        bullet.timeRate = self.timeRate
        (parentNode ?? world) << bullet

        missleCount -= 1
    }
}

extension MissleSiloNode {
    func onDraggingBegan(at location: CGPoint) {
        isDragging = true
        dragStart = radarSprite.position
    }
    func onDraggingEnded(at location: CGPoint) {
        isDragging = false
        dragStart = nil
    }

    func onDraggedAiming(from prevLocation: CGPoint, to location: CGPoint) {
        guard isDragging, let dragStart = dragStart else { return }

        let delta = location - prevLocation
        let anyPosition = dragStart + delta
        self.dragStart = anyPosition

        let angle = anyPosition.angle
        let minDist: CGFloat = radarUpgrade.missleSiloRadarMinDist
        let maxDist: CGFloat = radarUpgrade.missleSiloRadarMaxDist
        let newRadius = min(max(anyPosition.length, minDist), maxDist)
        let newPosition = CGPoint(r: newRadius, a: angle)
        radarSprite.position = newPosition

        startRotatingTo(angle: angle)
    }
}

extension MissleSiloNode {
    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func setRotation(_ angle: CGFloat) {
        baseSprite.zRotation = angle
        radarSprite.zRotation = angle
        turretBox.zRotation = angle
        turretNode.zRotation = angle
        rotateToComponent?.target = nil
    }
}
