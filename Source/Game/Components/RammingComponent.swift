////
///  RammingComponent.swift
//

class RammingComponent: Component {
    var acceleration: CGFloat = 10
    var currentSpeed: CGFloat?
    var maxSpeed: CGFloat = 25
    var maxTurningSpeed: CGFloat = 10
    var currentTarget: Node?
    var tempTarget: CGPoint? {
        didSet {
            if let target = tempTarget {
                tempTargetCountdown = max(3, 2 * (target - node.position).length / maxSpeed)
            }
        }
    }
    var tempTargetCountdown: CGFloat = 0
    var currentTargetLocation: CGPoint? {
        return tempTarget ?? currentTarget?.position
    }
    weak var intersectionNode: SKNode? {
        didSet {
            if let intersectionNode = intersectionNode,
                intersectionNode.frame.size == .zero
            {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }

    typealias OnRammed = (Node) -> ()
    var _onRammed: [OnRammed] = []
    func onRammed(_ handler: @escaping OnRammed) { _onRammed << handler }

    required override init() {
        super.init()
    }

    override func reset() {
        _onRammed = []
    }

    func removeNodeOnRammed() {
        onRammed { _ in
            guard let node = self.node else { return }
            node.removeFromParent()
        }
    }

    func struckTargetTest() -> Bool {
        return false
    }

    func removeTempTarget() {
        tempTarget = nil
    }

    override func update(_ dt: CGFloat) {
        if let tempTarget = tempTarget,
            tempTarget.distanceTo(node.position, within: 1) || tempTargetCountdown < 0
        {
            removeTempTarget()
        }
        else if tempTarget != nil {
            tempTargetCountdown -= dt
        }

        // if the node rammed into a target, call the handlers and remove this
        // component (to prevent multiple ramming events)
        if struckTargetTest() {
            return
        }

        if let targetLocation = currentTargetLocation {
            moveTowards(dt, targetLocation)
        }
    }

    func moveTowards(_ dt: CGFloat, _ targetLocation: CGPoint) {
        var maxSpeed = self.maxSpeed

        let destAngle: CGFloat
        if let rotateToComponent = node.rotateToComponent {
            rotateToComponent.target = node.position.angleTo(targetLocation)
            if rotateToComponent.isRotating {
                maxSpeed = maxTurningSpeed
            }
            destAngle = rotateToComponent.currentAngle
        }
        else {
            destAngle = node.position.angleTo(targetLocation)
            node.setRotation(destAngle)
        }

        var currentSpeed = maxSpeed
        if let prevSpeed = self.currentSpeed,
            let newSpeed = moveValue(prevSpeed, towards: maxSpeed, by: dt * acceleration)
        {
            currentSpeed = newSpeed
        }

        let vector = CGPoint(r: currentSpeed, a: destAngle)

        let newCenter = node.position + dt * vector
        self.currentSpeed = currentSpeed
        node.position = newCenter
    }

}


class PlayerRammingComponent: RammingComponent {

    func bindTo(targetingComponent: PlayerTargetingComponent) {
        targetingComponent.onTargetAcquired { target in
            self.currentTarget = target
        }
    }

    override func struckTargetTest() -> Bool {
        if let struckTarget = self.struckTarget() {
            let enemyDamage = min(struckTarget.healthComponent?.health ?? 0, node.healthComponent?.health ?? 0)

            switch struckTarget.playerComponent!.rammedBehavior {
            case .damaged:
                for handler in _onRammed {
                    handler(struckTarget)
                }
                return true
            case .attacks:
                node.healthComponent?.inflict(damage: enemyDamage)
            }
        }
        return false
    }

    private func struckTarget() -> Node? {
        guard let intersectionNode = intersectionNode else { return nil }

        if let players = (node.world?.players ?? currentTarget.map { [$0] }) {
            return players.firstMatch { player in
                guard let playerIntersectionNode = player.playerComponent?.intersectionNode else { return false }
                return player.playerComponent!.intersectable && intersectionNode.intersects(playerIntersectionNode) && node.touches(player)
            }
        }
        return nil
    }

}


class EnemyRammingComponent: RammingComponent {

    func bindTo(targetingComponent: EnemyTargetingComponent) {
        targetingComponent.onTargetAcquired { target in
            self.currentTarget = target
        }
    }

    override func struckTargetTest() -> Bool {
        if let struckTarget = self.struckTarget() {
            for handler in _onRammed {
                handler(struckTarget)
            }
            return true
        }
        return false
    }

    private func struckTarget() -> Node? {
        guard let intersectionNode = intersectionNode else { return nil }

        if let enemies = (node.world?.enemies ?? currentTarget.map { [$0] }) {
            return enemies.firstMatch { enemy in
                guard let enemyIntersectionNode = enemy.enemyComponent?.intersectionNode else { return false }
                return enemy.enemyComponent!.targetable && intersectionNode.intersects(enemyIntersectionNode) && node.touches(enemy)
            }
        }
        return nil
    }

}
