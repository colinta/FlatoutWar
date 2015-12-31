//
//  SpriteKit.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/17/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension SKTexture {
    convenience init(id: ImageIdentifier) {
        self.init(image: Artist.generate(id))
    }
}

extension SKSpriteNode {
    convenience init(id: ImageIdentifier) {
        let texture = SKTexture(id: id)
        self.init(texture: texture)
        self.setScale(0.5)
    }
}

extension SKNode {
    func rotateTowards(node node: SKNode) {
        let point = convertPoint(node.position, fromNode: node.parent!)
        rotateTowards(point: point)
    }

    func rotateTowards(point point: CGPoint) {
        zRotation = point.angle
    }
}
