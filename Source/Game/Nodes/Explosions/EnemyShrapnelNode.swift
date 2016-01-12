//
//  EnemyShrapnelNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class EnemyShrapnelNode: Node {

    required init(type: ImageIdentifier.EnemyType, size: ImageIdentifier.Size) {
        super.init()
        self << SKSpriteNode(id: .EnemyShrapnel(type: type, size: size))
    }

    func setupAround(node: Node, at location: CGPoint? = nil) {
        position = location ?? node.position
        zRotation = node.zRotation

        let duration: CGFloat = 0.5

        let rotate = KeepRotatingComponent()
        rotate.rate = rand(min: 1, max: 2)
        addComponent(rotate)

        let move = MoveToComponent()
        let minDist: CGFloat = node.radius * 3
        let maxDist: CGFloat = node.radius * 6
        let dest = CGPoint(r: rand(min: minDist, max: maxDist), a: rand(TAU))
        move.target = node.position + dest
        move.duration = duration
        addComponent(move)

        let fade = FadeToComponent()
        fade.target = 0
        fade.duration = duration
        fade.removeNodeOnFade()
        addComponent(fade)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
