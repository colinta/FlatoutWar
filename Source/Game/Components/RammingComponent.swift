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
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == .zero {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }

    typealias OnRammed = (Node) -> ()
    var _onRammed: [OnRammed] = []
    func onRammed(handler: OnRammed) { _onRammed << handler }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func didAddToNode() {
        super.didAddToNode()
        if intersectionNode == nil {
            fatalError("intersectionNode is required")
        }
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

    override func update(dt: CGFloat) {
        if let tempTarget = tempTarget
        where tempTarget.distanceTo(node.position, within: 1) || tempTargetCountdown < 0
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

    func moveTowards(dt: CGFloat, _ targetLocation: CGPoint) {
        var maxSpeed = self.maxSpeed

        let destAngle: CGFloat
        if let rotateToComponent = node.rotateToComponent {
            rotateToComponent.target = node.position.angleTo(targetLocation)
            if rotateToComponent.isRotating {
                maxSpeed = maxTurningSpeed
            }
            destAngle = rotateToComponent.currentAngle ?? node.zRotation
        }
        else {
            destAngle = node.position.angleTo(targetLocation)
            node.rotateTo(destAngle)
        }

        var currentSpeed = maxSpeed
        if let prevSpeed = self.currentSpeed,
            newSpeed = moveValue(prevSpeed, towards: maxSpeed, by: dt * acceleration)
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

    func bindTo(targetingComponent targetingComponent: PlayerTargetingComponent) {
        targetingComponent.onTargetAcquired { target in
            self.currentTarget = target
        }
    }

    override func struckTargetTest() -> Bool {
        if let struckTarget = self.struckTarget() {
            let enemyDamage = min(struckTarget.healthComponent?.health ?? 0, node.healthComponent?.health ?? 0)

            switch struckTarget.playerComponent!.rammedBehavior {
            case .Damaged:
                for handler in _onRammed {
                    handler(struckTarget)
                }
                return true
            case .Attacks:
                node.healthComponent?.inflict(enemyDamage)
            }
        }
        return false
    }

    private func struckTarget() -> Node? {
        if let players = (node.world?.players ?? currentTarget.map { [$0] }) {
            return players.firstMatch { player in
                return player.playerComponent!.intersectable && intersectionNode!.intersectsNode(player.playerComponent!.intersectionNode!) && node.touches(player)
            }
        }
        return nil
    }

}


class EnemyRammingComponent: RammingComponent {

    func bindTo(targetingComponent targetingComponent: EnemyTargetingComponent) {
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
        if let enemies = (node.world?.enemies ?? currentTarget.map { [$0] }) {
            return enemies.firstMatch { enemy in
                return enemy.enemyComponent!.targetable && intersectionNode!.intersectsNode(enemy.enemyComponent!.intersectionNode!) && node.touches(enemy)
            }
        }
        return nil
    }

}
