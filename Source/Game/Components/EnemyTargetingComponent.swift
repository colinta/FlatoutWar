////
///  EnemyTargetingComponent.swift
//

class EnemyTargetingComponent: Component {
    var radius: CGFloat?
    var sweepAngle: CGFloat?
    private var avoidTarget: Node?
    var currentTarget: Node? {
        didSet {
            if currentTarget != oldValue {
                currentTargetVector = nil
                currentTargetPrevLocation = nil
            }
        }
    }
    var turret: SKNode?
    var reallySmart = false
    var bulletSpeed: CGFloat?
    var currentTargetVector: CGPoint?
    var currentTargetPrevLocation: CGPoint?

    typealias OnTargetAcquired = ((target: Node?)) -> Void
    var _onTargetAcquired: [OnTargetAcquired] = []
    func onTargetAcquired(_ handler: @escaping OnTargetAcquired) { _onTargetAcquired.append(handler) }

    override func reset() {
        super.reset()
        avoidTarget = nil
        currentTarget = nil
        _onTargetAcquired = []
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

    override func update(_ dt: CGFloat) {
        let prevTarget = currentTarget
        if let enemy = currentTarget,
            !isViableTarget(enemy)
        {
            currentTarget = nil
        }

        let isRotating = node.rotateToComponent?.isRotating ?? false
        if let world = node.world, currentTarget == nil, !isRotating {
            acquireTarget(world: world)
        }

        if prevTarget != currentTarget {
            for handler in _onTargetAcquired {
                handler(currentTarget)
            }
        }

        if let prevLocation = currentTargetPrevLocation,
            let currentLocation = currentTarget?.position,
            reallySmart
        {
            currentTargetVector = (currentLocation - prevLocation) / dt
        }

        currentTargetPrevLocation = currentTarget?.position
    }

    func isViableTarget(_ enemy: Node) -> Bool {
        guard let radius = radius,
            let world = node.world,
            world.enemies.contains(enemy),
            enemy.enemyComponent!.targetable
        else {
            return false
        }

        let enemyPosition = node.convertPosition(enemy)
        guard enemyPosition.lengthWithin(radius + enemy.radius) else
        {
            return false
        }
        // no sweepAngle means 360° targeting
        guard let sweepAngle = sweepAngle else { return true }

        let angle = enemyPosition.angle
        let normalized: CGFloat
        if let turret = turret {
            normalized = deltaAngle(angle, target: turret.zRotation)
        }
        else {
            normalized = angle
        }
        let sweep: CGFloat
        let reallyCloseAdjustment: CGFloat = 40
        if enemyPosition.lengthWithin(reallyCloseAdjustment) {
            sweep = sweepAngle + 20.degrees
        }
        else {
            sweep = sweepAngle
        }
        return abs(normalized) <= sweep / 2.0
    }

    func angleToCurrentTarget() -> CGFloat? {
        guard let currentTarget = currentTarget else {
            return nil
        }

        if reallySmart {
            if let currentVector = currentTargetVector,
                let parent = currentTarget.parent,
                let bulletSpeed = bulletSpeed
            {
                let time = node.distanceTo(currentTarget) / bulletSpeed
                let predictedPosition = currentTarget.position + currentVector * time
                let relativePosition = node.convert(predictedPosition, from: parent)
                return relativePosition.angle
            }
            return nil
        }

        return node.angleTo(currentTarget)
    }

    func reacquireAvoidingCurrent() {
        avoidTarget = currentTarget
        currentTarget = nil
    }

    private func acquireTarget(world: World) {
        if let currentTarget = currentTarget,
            currentTarget.world != node.world
        {
            self.currentTarget = nil
        }

        var bestTarget: Node? = currentTarget
        var bestDistance: CGFloat = 0
        for enemy in world.enemies where isViableTarget(enemy) && enemy != avoidTarget {
            let enemyPosition = node.convertPosition(enemy)
            let enemyDistance = enemyPosition.roughLength

            if bestTarget == nil {
                bestTarget = enemy
                bestDistance = enemyDistance
            }
            else if enemyDistance < bestDistance {
                bestTarget = enemy
                bestDistance = enemyDistance
            }
        }

        currentTarget = bestTarget
        avoidTarget = nil
    }

}
