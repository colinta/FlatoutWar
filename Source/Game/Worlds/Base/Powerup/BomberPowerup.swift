//
//  BomberPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BomberPowerup: Powerup {
    override var name: String { return "BOMBER" }
    override var weight: Weight { return .Rare }
    override var powerupType: ImageIdentifier.PowerupType? { return .Bomber }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()

        if let level = level {
            let pathNode = PathDrawingNode()
            level << pathNode
            powerupEnabled = false

            let prevDefault = level.defaultNode
            level.defaultNode = pathNode

            let touchComponent = pathNode.touchableComponent!
            touchComponent.on(.Up) { location in
                var t: CGFloat = 0
                while t < 1 {
                    level << Dot(at: pathNode.pathFn(t))
                    t += 0.001
                }
                level << Dot(at: pathNode.pathFn(1))

                level.defaultNode = prevDefault
                self.powerupEnabled = true

                let position = pathNode.convertPoint(location, toNode: level)
                let plane = Node(at: level.playerNode.position)
                plane << SKSpriteNode(id: .Bomber(numBombs: 8))
                plane.alpha = 0
                level << plane

                plane.moveTo(position, duration: 1)
                plane.fadeTo(1, duration: 1)
                pathNode.removeFromParent()
            }
        }
    }

}
