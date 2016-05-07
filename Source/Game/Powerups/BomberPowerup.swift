//
//  BomberPowerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BomberPowerup: Powerup {
    override var name: String { return "BOMBER" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Bomber }

    required override init() {
        super.init()
        self.count = nil
        self.timeout = 60
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let slowmo: CGFloat = 0.333
        level.timeRate = slowmo

        let pathNode = PathDrawingNode()
        level << pathNode
        powerupEnabled = false

        let prevDefault = level.defaultNode
        level.defaultNode = pathNode

        let touchComponent = pathNode.touchableComponent!
        touchComponent.on(.Up) { location in
            pathNode.removeFromParent()

            let bomber = BomberPowerupNode()
            bomber.timeRate = 1 / slowmo
            bomber.scaleTo(1, start: 1.5, duration: 1)
            bomber.fadeTo(1, start: 0, duration: 1)
            bomber.followPathComponent.pathFn = pathNode.pathFn
            bomber.followPathComponent.onArrived {
                bomber.timeRate = 1
                level.timeRate = 1

                bomber.scaleTo(1.5, duration: 1)
                bomber.fadeTo(0, duration: 1, removeNode: true)
                completion()
            }
            level << bomber

            level.defaultNode = prevDefault
            self.powerupEnabled = true
        }
    }

}
