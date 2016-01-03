//
//  IntersectsTestWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class IntersectsTestWorld: World {
    let n1 = Node(at: CGPoint(x: 3, y: 0))
    let n2 = Node(at: CGPoint(x: -3, y: 0))
    let a1 = SKSpriteNode(id: .Enemy(type: .Dozer, health: 50))
    let a2 = SKSpriteNode(id: .Enemy(type: .Dozer, health: 50))

    override func populateWorld() {
        pauseable = false

        n1 << a1
        n1.shape = .Rect
        n1.size = CGSize(width: 5, height: 50)
        n1.zRotation = 0.degrees
        self << n1

        n2 << a2
        n2.shape = .Rect
        n2.size = CGSize(width: 5, height: 50)
        n2.zRotation = 45.degrees
        self << n2

        setScale(3)

        defaultNode = self

        let touchableComponent = TouchableComponent()
        var rotating = false
        touchableComponent.on(.Up) { _ in
            rotating = !rotating
        }
        touchableComponent.onDragged { (prevLocation, location) in
            if rotating {
                self.n1.zRotation = self.n1.zRotation + location.angle - prevLocation.angle
            }
            else {
                self.n1.position = self.n1.position + (location - prevLocation)
            }
        }
        self.addComponent(touchableComponent)
    }

    override func update(dt: CGFloat) {
        n1.alpha = n1.touches(n2) ? 1 : 0.5
        n2.alpha = n2.touches(n1) ? 1 : 0.5
    }
}
