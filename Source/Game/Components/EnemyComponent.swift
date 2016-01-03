//
//  EnemyComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyComponent: Component {
    var experience: Int = 0

    typealias OnAttacked = (projectile: Node) -> Void
    var _onAttacked: [OnAttacked] = []
    func onAttacked(handler: OnAttacked) { _onAttacked << handler }
    private(set) var currentTarget: Node?

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
            if currentTarget.world == world {
                return currentTarget
            }
        }

        var bestTarget: Node? = nil
        var bestDistance: CGFloat = 0
        var bestPriority = PlayerComponent.Priority.Default

        for player in world.players {
            let playerDistance = node.position.roughDistanceTo(player.position)
            let playerPriority = player.playerComponent!.priority

            if bestTarget == nil {
                bestTarget = player
                bestDistance = playerDistance
                bestPriority = playerPriority
            }
            else if bestPriority < playerPriority {
                bestTarget = player
                bestDistance = playerDistance
                bestPriority = playerPriority
            }
            else if bestPriority == playerPriority && playerDistance < bestDistance {
                bestTarget = player
                bestDistance = playerDistance
                bestPriority = playerPriority
            }
        }

        return bestTarget
    }

    override func update(dt: CGFloat) {
        if let world = node.world {
            currentTarget = acquireTarget(world)
        }
    }

}
