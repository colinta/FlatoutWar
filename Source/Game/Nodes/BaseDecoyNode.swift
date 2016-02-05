//
//  BaseDecoyNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let startingHealth: Float = 35

class BaseDecoyNode: Node {

    required init() {
        super.init()
        size = CGSize(30)
        zRotation = rand(TAU)

        let sprite = SKSpriteNode(id: .Powerup(type: .Decoy))
        self << sprite

        let playerComponent = PlayerComponent()
        playerComponent.intersectionNode = sprite
        playerComponent.rammedBehavior = .Attacks
        addComponent(playerComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.maxAngularSpeed = 3.5
        rotateToComponent.angularAccel = 3
        rotateToComponent.target = rand(TAU)
        rotateToComponent.onRotated {
            rotateToComponent.target = rand(TAU)
        }
        addComponent(rotateToComponent)

        let healthComponent = HealthComponent(health: startingHealth)
        healthComponent.onKilled {
            self.fadeTo(0, duration: 0.5, removeNode: true)
        }
        addComponent(healthComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
