//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: World {

    override func populateWorld() {
        let powerups = Powerup.All
        let r: CGFloat = 80
        for (index, powerup) in powerups.enumerate() {
            let a = TAU / CGFloat(powerups.count) * CGFloat(index)
            let n = Node(at: CGPoint(r: r, a: a))
            n << powerup.buttonIcon()
            self << n
        }
    }

    override func worldTouchEnded(worldLocation: CGPoint) {
        super.worldTouchEnded(worldLocation)
        if timeRate < 1 {
            cameraNode = Node(at: .Zero)
            setScale(1)
            timeRate = 1
        }
        else {
            cameraNode = Node(at: worldLocation * 3)
            setScale(3)
            timeRate = 0.1
        }
    }

}
