//
//  SpriteKit.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/17/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private var generatedTextures = [String: SKTexture]()

extension SKTexture {
    static func id(id: ImageIdentifier) -> SKTexture {
        let cacheName = id.name
        if let cached = generatedTextures[cacheName] {
            return cached
        }

        let texture = SKTexture(image: Artist.generate(id))
        generatedTextures[cacheName] = texture
        return texture
    }
}

extension SKSpriteNode {
    convenience init(id: ImageIdentifier) {
        let texture = SKTexture.id(id)
        self.init(texture: texture)
        self.setScale(0.5)
    }
}

extension SKNode {
    func convertPosition(node: SKNode) -> CGPoint {
        if node.parent == self.parent {
            return convertPoint(node.position, fromNode: node.parent!)
        }
        else {
            return convertPoint(CGPointZero, fromNode: node)
        }
    }

    func rotateTowards(node node: SKNode) {
        let point = convertPosition(node)
        rotateTowards(point: point)
    }

    func rotateTowards(point point: CGPoint) {
        zRotation = point.angle
    }
}
