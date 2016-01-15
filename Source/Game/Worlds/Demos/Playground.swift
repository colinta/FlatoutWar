//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: World {

    override func populateWorld() {
        let b = Node()
        self << b

        let moveTo = MoveToComponent()
        moveTo.target = CGPoint(r: 100, a: rand(TAU))
        moveTo.duration = 10
        b.addComponent(moveTo)

        50.times {
            let n = Node()
            n << SKShapeNode(circleOfRadius: 5)
            b << n

            let wandering = WanderingComponent()
            wandering.wanderingRadius = 100
            wandering.maxSpeed = 100
            wandering.centeredAround = CGPointZero
            n.addComponent(wandering)
        }
    }

}
