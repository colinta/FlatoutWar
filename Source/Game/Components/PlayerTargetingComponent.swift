////
///  PlayerTargetingComponent.swift
//

class PlayerTargetingComponent: Component {
    var targetingEnabled: Bool = true
    var currentTarget: Node?

    typealias OnTargetAcquired = ((target: Node?)) -> Void
    var _onTargetAcquired: [OnTargetAcquired] = []
    func onTargetAcquired(_ handler: @escaping OnTargetAcquired) { _onTargetAcquired << handler }

    required override init() {
        super.init()
    }

    override func reset() {
        super.reset()
        currentTarget = nil
        _onTargetAcquired = []
    }

    func acquireTarget(world: World) -> Node? {
        guard targetingEnabled else { return nil }

        if let currentTarget = currentTarget,
            currentTarget.world == world,
            currentTarget.playerComponent!.targetable
        {
            return currentTarget
        }

        let targets = world.players.filter { player in
            return player.playerComponent!.targetable
        }.map { (player) -> (player: Node, dist: CGFloat) in
            return (player: player, dist: node.position.distanceTo(player.position))
        }.sorted { a, b in
            return a.dist < b.dist
        }
        guard targets.count > 0 else { return nil }

        var minDist = targets[0].dist
        var maxDist = targets[0].dist
        for entry in targets {
            minDist = min(minDist, entry.dist)
            maxDist = max(maxDist, entry.dist)
        }
        let threshold = minDist + max((maxDist - minDist) * 0.25, 40)
        return targets.filter { entry in
            if entry.player is BasePlayerNode {
                return true
            }
            return entry.dist < threshold
        }.randWeighted { entry in
            return Float(entry.dist)
        }?.player
    }

    override func update(_ dt: CGFloat) {
        guard targetingEnabled, let world = node.world else { return }

        let newTarget = acquireTarget(world: world)
        if let newTarget = newTarget, newTarget != currentTarget {
            for handler in _onTargetAcquired {
                handler(newTarget)
            }
        }
        else if newTarget == nil && currentTarget != nil {
            for handler in _onTargetAcquired {
                handler(newTarget)
            }
        }
        currentTarget = newTarget
    }

}
