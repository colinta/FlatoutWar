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

    func textureId(id: ImageIdentifier) {
        let texture = SKTexture.id(id)
        self.texture = texture
        size = texture.size() * xScale
    }
}

extension SKNode {

    func distanceTo(node: SKNode) -> CGFloat {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.distanceTo(posNode)
        }
        let position = convertPosition(node)
        return position.length
    }

    func distanceTo(node: SKNode, within radius: CGFloat) -> Bool {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.distanceTo(posNode, within: radius)
        }
        let position = convertPosition(node)
        return position.lengthWithin(radius)
    }

    func angleTo(node: SKNode) -> CGFloat {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.angleTo(posNode)
        }
        let position = convertPosition(node)
        return position.angle
    }

    func convertPosition(node: SKNode) -> CGPoint {
        if node.parent == nil || self.parent == nil {
            return node.position - self.position
        }
        else if node.parent == self.parent {
            return convertPoint(node.position, fromNode: node.parent!)
        }
        else {
            return convertPoint(CGPointZero, fromNode: node)
        }
    }

}
