////
///  MissleSiloNode.swift
//

private let startingHealth: Float = 50

class MissleSiloNode: Node, DraggableNode {
    var radarUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var bulletUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }
    var rotateUpgrade: HasUpgrade = .False { didSet { updateUpgrades() } }

    let armyComponent = SelectableArmyComponent()

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
            let missleSprite = SKSpriteNode(id: .Missle)
            missleSprite.z = .AbovePlayer
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

        firingComponent?.enabled = missleCount > 0
    }

    fileprivate func updateUpgrades() {
        radarSprite.textureId(.MissleSiloRadar(upgrade: radarUpgrade))
        baseSprite.textureId(.MissleSilo(upgrade: bulletUpgrade, health: healthComponent?.healthInt ?? 100))
        placeholder.textureId(.MissleSilo(upgrade: bulletUpgrade, health: 100))
        turretBox.textureId(.MissleSiloBox(upgrade: bulletUpgrade))

        draggableComponent?.speed = rotateUpgrade.missleSiloMovementSpeed

        targetingComponent?.radius = radarUpgrade.missleSiloRadarRadius

        firingComponent?.targetsPreemptively = true
        firingComponent?.damage = bulletUpgrade.missleSiloBulletDamage

        rotateToComponent?.maxAngularSpeed = rotateUpgrade.baseAngularSpeed
        rotateToComponent?.angularAccel = rotateUpgrade.baseAngularAccel

        targetingComponent?.bulletSpeed = bulletUpgrade.missleSiloBulletSpeed
        size = baseSprite.size
    }

    let radarSprite = SKSpriteNode()
    let baseNode = Node()
    let baseSprite = SKSpriteNode()
    let turretNode = Node()
    let turretBox = SKSpriteNode()
    var maxMissleCount: Int = 3
    private var missleCreationTimer: CGFloat = 0
    var missleCount: Int {
        didSet {
            updateMissleSprites()
        }
    }
    fileprivate var missleSprites: [SKSpriteNode] = []
    let placeholder = SKSpriteNode()

    var isDragging = false
    var dragStart: CGPoint?

    required init() {
        missleCount = maxMissleCount
        super.init()

        self << placeholder
        placeholder.alpha = 0.5
        placeholder.isHidden = true

        baseSprite.z = .Player
        radarSprite.z = .BelowPlayer
        turretBox.z = .Above

        self << baseNode
        self << radarSprite
        baseNode << baseSprite
        self << turretNode
        turretBox.anchorPoint = CGPoint(x: 0.75, y: 0.5)
        self << turretBox

        let playerComponent = PlayerComponent()
        playerComponent.targetable = false
        playerComponent.intersectionNode = baseNode
        addComponent(playerComponent)

        let targetingComponent = EnemyTargetingComponent()
        targetingComponent.turret = radarSprite
        addComponent(targetingComponent)

        let firingComponent = FiringComponent()
        firingComponent.onFireTarget(self.fireBullet)
        addComponent(firingComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onHurt { damage in
            self.baseSprite.textureId(.MissleSilo(upgrade: self.bulletUpgrade, health: healthComponent.healthInt))
        }
        healthComponent.onKilled {
            self.world?.unselectNode(self)
            self.cannonEnabled(isMoving: false)
        }
        addComponent(healthComponent)

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(shape: .Circle)
        touchableComponent.on(.DragBeganOutside, onDraggingBegan)
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
            self.cannonEnabled(isMoving: isMoving)
            self.world?.unselectNode(self)
            if !isMoving {
                self.world?.reacquirePlayerTargets()
            }
        }
        addComponent(draggableComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        rotateToComponent.applyTo = baseNode
        addComponent(rotateToComponent)

        let cursor = CursorNode()
        armyComponent.cursorNode = cursor
        self << cursor

        armyComponent.radarNode = radarSprite
        addComponent(armyComponent)

        missleCreationTimer = rotateUpgrade.missleSiloReloadTime
        updateUpgrades()
        updateMissleSprites()

        radarSprite.position = CGPoint(r: 100, a: rand(TAU))
        rotateTo(radarSprite.position.angle)
    }

    required init?(coder: NSCoder) {
        missleCount = coder.decodeInt(key: "missleCount") ?? 0
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
        encoder.encode(missleCount, forKey: "missleCount")
    }

    override func clone() -> Node {
        let node = super.clone() as! MissleSiloNode
        node.rotateUpgrade = rotateUpgrade
        node.bulletUpgrade = bulletUpgrade
        node.radarUpgrade = radarUpgrade
        return node
    }

    override func update(_ dt: CGFloat) {
        if let angle = rotateToComponent?.destAngle {
            radarSprite.zRotation = angle
        }

        let angle = firingComponent?.angle ?? baseNode.zRotation
        turretNode.zRotation = angle
        turretBox.zRotation = angle

        if missleCount < maxMissleCount {
            missleCreationTimer -= dt

            if missleCreationTimer <= 0 {
                missleCreationTimer = rotateUpgrade.missleSiloReloadTime

                if missleCount == 0 {
                    firingComponent?.lastFiredCooldown = 0
                }

                missleCount += 1
                firingComponent?.cooldown = bulletUpgrade.missleSiloCooldown
            }
        }
    }
}

// MARK: Enable/Disable during moving/death
extension MissleSiloNode {
    func cannonEnabled(isMoving: Bool) {
        armyComponent.isMoving = isMoving
        firingComponent?.enabled = armyComponent.armyEnabled && missleCount > 0
    }
}

// MARK: Fire Bullet
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
        let missle = MissleNode(
            damage: bulletUpgrade.missleSiloBulletDamage,
            speed: bulletUpgrade.missleSiloBulletSpeed,
            radius: bulletUpgrade.missleSiloSplashRadius,
            target: target)
        missle.position = position + missleOffset
        missle.zRotation = zRotation
        (parentNode ?? world) << missle

        missleCount -= 1
    }
}

// MARK: Touch events
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

// MARK: Rotation
extension MissleSiloNode {
    func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func rotateTo(_ angle: CGFloat) {
        baseNode.zRotation = angle
        radarSprite.zRotation = angle
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }
}
