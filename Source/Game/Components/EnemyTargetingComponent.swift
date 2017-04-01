////
///  EnemyTargetingComponent.swift
//

class EnemyTargetingComponent: Component {
    var minRadius: CGFloat?
    var radius: CGFloat?
    var sweepAngle: CGFloat?
    var sweepWidth: CGFloat?
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

    typealias OnTargetAcquired = (Node?) -> Void
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

    private func turretPosition(target: SKNode) -> CGPoint {
        if let turret = turret {
            return turret.convertPosition(target) * turret.xScale
        }
        else {
            return node.convertPosition(target)
        }
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

        if reallySmart {
            if let prevLocation = currentTargetPrevLocation,
                let currentLocation = currentTarget?.position
            {
                currentTargetVector = (currentLocation - prevLocation) / dt
            }
            currentTargetPrevLocation = currentTarget?.position
        }
    }

    func isViableTarget(_ enemy: Node) -> Bool {
        guard
            let world = node.world,
            world.enemies.contains(enemy),
            enemy.enemyComponent!.targetable
        else {
            return false
        }

        let enemyPosition = turretPosition(target: enemy)
        if let radius = radius,
            !enemyPosition.lengthWithin(radius + enemy.radius)
        {
            return false
        }

        if let minRadius = minRadius,
            enemyPosition.lengthWithin(minRadius - enemy.radius)
        {
            return false
        }

        // no sweepAngle means 360° targeting
        if let sweepAngle = sweepAngle {
            return viableTarget(enemy, position: enemyPosition, inAngle: sweepAngle)
        }
        else if let sweepWidth = sweepWidth {
            return viableTarget(enemy, position: enemyPosition, inWidth: sweepWidth)
        }
        else {
            return true
        }
    }

    func viableTarget(_ enemy: Node, position enemyPosition: CGPoint, inWidth sweepWidth: CGFloat) -> Bool {
        let radius = enemyPosition.length
        let angle = enemyPosition.angle - node.zRotation

        let y: CGFloat = abs(radius * sin(angle))
        return y <= sweepWidth
    }

    func viableTarget(_ enemy: Node, position enemyPosition: CGPoint, inAngle sweepAngle: CGFloat) -> Bool {
        let angle = enemyPosition.angle

        let sweep: CGFloat
        let reallyCloseAdjustment: CGFloat = 40
        if enemyPosition.lengthWithin(reallyCloseAdjustment) {
            sweep = sweepAngle + 20.degrees
        }
        else {
            sweep = sweepAngle
        }
        return abs(angle) <= sweep / 2.0
    }

    func firingPosition() -> CGPoint? {
        guard let currentTarget = currentTarget else {
            return nil
        }

        if reallySmart {
            if let currentVector = currentTargetVector,
                let parent = currentTarget.parent,
                let bulletSpeed = bulletSpeed
            {
                let time = (turret ?? node).distanceTo(currentTarget) / bulletSpeed
                let predictedPosition = currentTarget.position + currentVector * time
                let relativePosition = node.convert(predictedPosition, from: parent)
                return relativePosition
            }
            return nil
        }

        return node.convertPosition(currentTarget)
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

        if currentTarget == avoidTarget {
            currentTarget = nil
        }

        var bestTarget: Node? = currentTarget
        var bestDistance: CGFloat = 0
        for enemy in world.enemies where isViableTarget(enemy) && enemy != avoidTarget {
            let enemyPosition = turretPosition(target: enemy)
            let enemyDistance = enemyPosition.roughLength

            if bestTarget == nil {
                bestTarget = enemy
                bestDistance = enemyDistance
                avoidTarget = nil
            }
            else if enemyDistance < bestDistance {
                bestTarget = enemy
                bestDistance = enemyDistance
                avoidTarget = nil
            }
        }

        currentTarget = bestTarget
    }

}
