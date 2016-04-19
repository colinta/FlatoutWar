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
        if let cacheName = cacheName,
            cached = generatedTextures[cacheName]
        {
            return cached
        }

        let texture = SKTexture(image: Artist.generate(id))
        if let cacheName = cacheName {
            generatedTextures[cacheName] = texture
        }
        return texture
    }
}

extension SKLightNode {
    static func defaultLight() -> SKLightNode {
        let light = SKLightNode()
        light.falloff = 0.01
        light.ambientColor = UIColor(hex: 0x5f5f5f)
        light.lightColor = .whiteColor()
        return light
    }
}

extension SKSpriteNode {
    convenience init(id: ImageIdentifier, at position: CGPoint = .zero) {
        let texture = SKTexture.id(id)
        self.init(texture: texture)
        setScale(0.5)
        self.position = position
        self.shadowedBitMask = 0xFFFFFFFF
    }

    func textureId(id: ImageIdentifier) {
        if self.texture == nil {
            setScale(0.5)
        }
        let texture = SKTexture.id(id)
        self.texture = texture
        size = texture.size() * xScale
    }
}

extension SKNode {
    var z: Z {
        set { zPosition = newValue.rawValue }
        get { return Z(rawValue: zPosition) ?? Z.Default }
    }

    static func size(size: CGSize) -> SKNode {
        return SKSpriteNode(texture: nil, size: size)
    }

    func isParentOf(child: SKNode) -> Bool {
        return child.inParentHierarchy(self)
    }

    func rotateTo(angle: CGFloat) {
        zRotation = angle
    }

    func rotateTowards(node: SKNode) {
        let angle = angleTo(node)
        rotateTo(angle)
    }

    func rotateTowards(point point: CGPoint) {
        let angle = (point - position).angle
        rotateTo(angle)
    }

    func distanceTo(node: SKNode) -> CGFloat {
        return sqrt(roughDistanceTo(node))
    }

    func roughDistanceTo(node: SKNode) -> CGFloat {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world where world.isParentOf(self) && world.isParentOf(node) {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.roughDistanceTo(posNode)
        }
        let position = convertPosition(node)
        return position.roughLength
    }

    func distanceTo(node: SKNode, within radius: CGFloat) -> Bool {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world where world.isParentOf(self) && world.isParentOf(node) {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.distanceTo(posNode, within: radius)
        }
        let position = convertPosition(node)
        return position.lengthWithin(radius)
    }

    func angleTo(node: SKNode) -> CGFloat {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world where world.isParentOf(self) && world.isParentOf(node) {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return (posNode - posSelf).angle
        }
        let position = convertPosition(node)
        return position.angle
    }

    func convertPosition(node: SKNode) -> CGPoint {
        if node.parent == nil || self.parent == nil {
            if self is World {
                return node.position
            }
            else if node is World {
                return -1 * self.position
            }
            else {
                return node.position - self.position
            }
        }
        else if node.parent == self.parent {
            return convertPoint(node.position, fromNode: node.parent!)
        }
        else {
            return convertPoint(.zero, fromNode: node)
        }
    }

}
