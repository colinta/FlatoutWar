//
//  EnemyComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyComponent: Component {
    var experience: Int = 0
    private(set) var currentTarget: Node?

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
        if let currentTarget = currentTarget {
            if currentTarget.world == world && currentTarget.playerComponent!.targetable {
                return currentTarget
            }
        }

        var bestTarget: Node? = nil
        var bestDistance: CGFloat = 0

        for player in world.players {
            let playerDistance = node.position.roughDistanceTo(player.position)

            if bestTarget == nil {
                bestTarget = player
                bestDistance = playerDistance
            }
            else if playerDistance < bestDistance {
                bestTarget = player
                bestDistance = playerDistance
            }
        }

        return bestTarget
    }

    override func update(dt: CGFloat) {
        guard let world = node.world else { return }

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
