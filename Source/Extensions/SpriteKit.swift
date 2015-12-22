//
//  SpriteKit.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/17/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension SKSpriteNode {
    convenience init(id: ImageIdentifier) {
        let texture = SKTexture(image: Artist.generate(id))
        self.init(texture: texture)
        self.setScale(0.5)
    }
}

extension SKNode {
    func rotateTowards(node node: SKNode) {
        let point = convertPoint(CGPointZero, fromNode: node)
        rotateTowards(point: point)
    }

    func rotateTowards(point point: CGPoint) {
        zRotation = point.angle
    }
}
