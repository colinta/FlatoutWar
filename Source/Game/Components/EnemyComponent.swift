//
//  EnemyComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

protocol EnemyNode: class {
}

class EnemyComponent: Component {
    private var _targetable: Bool = true
    var targetable: Bool {
        get { return _targetable && enabled }
        set { _targetable = newValue }
    }
    var targetingEnabled: Bool = true
    var experience: Int = 0
    var currentTarget: Node?
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == .Zero {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }

    typealias OnTargetAcquired = (target: Node?) -> Void
    var _onTargetAcquired: [OnTargetAcquired] = []
    func onTargetAcquired(handler: OnTargetAcquired) { _onTargetAcquired << handler }

    typealias OnAttacked = (projectile: Node) -> Void
    var _onAttacked: [OnAttacked] = []
    func onAttacked(handler: OnAttacked) { _onAttacked << handler }

    override func reset() {
        super.reset()
        currentTarget = nil
        _onAttacked = []
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func attacked(by node: Node) {
        for handler in _onAttacked {
            handler(projectile: node)
        }
    }

    func acquireTarget(world: World) -> Node? {
        guard targetingEnabled else { return nil }

        if let currentTarget = currentTarget
        where currentTarget.world == world && currentTarget.playerComponent!.targetable
        {
            return currentTarget
        }

        let targets = world.players.filter { player in
            return player.playerComponent!.targetable
        }.map { (player) -> (player: Node, dist: CGFloat) in
            return (player: player, dist: node.position.distanceTo(player.position))
        }.sort { a, b in
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

    override func update(dt: CGFloat) {
        guard let world = node.world else { return }

        if targetingEnabled {
            let newTarget = acquireTarget(world)
            if let newTarget = newTarget where newTarget != currentTarget {
                for handler in _onTargetAcquired {
                    handler(target: newTarget)
                }
            }
            else if newTarget == nil && currentTarget != nil {
                for handler in _onTargetAcquired {
                    handler(target: newTarget)
                }
            }
            currentTarget = newTarget
        }
    }

}
