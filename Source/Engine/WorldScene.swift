//
//  WorldScene.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class WorldScene: SKScene {
    let world: World
    let ui = SKNode()
    var prevTime: NSTimeInterval?

    required init(size: CGSize, world: World) {
        self.world = world
        super.init(size: size)
        anchorPoint = CGPoint(0.5, 0.5)

        self << world
        self << ui
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(currentTime: NSTimeInterval) {
        if let prevTime = prevTime {
            let dt = CGFloat(currentTime - prevTime)
            world.updateNodes(dt)
        }
        prevTime = currentTime
    }
}
