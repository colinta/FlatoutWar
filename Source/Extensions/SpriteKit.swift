////
///  SpriteKit.swift
//

private var generatedTextures: [String: SKTexture] = [:]

extension SKTexture {
    static func clearCache() {
        generatedTextures = [:]
    }

    static func id(_ id: ImageIdentifier, scale: Artist.Scale = .Default) -> SKTexture {
        let cacheName = id.name
        if let cacheName = cacheName {
            if let cached = generatedTextures[cacheName] {
                return cached
            }
            else if let atlasName = id.atlasName {
                let atlas = SKTextureAtlas(named: atlasName)
                let texture = atlas.textureNamed(cacheName)
                return texture
            }
        }

        let image = Artist.generate(id, scale: scale)
        let texture = SKTexture(image: image)
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
        light.lightColor = .white
        return light
    }
}

extension SKSpriteNode {
    convenience init(id: ImageIdentifier, at position: CGPoint = .zero, scale: Artist.Scale = .Default) {
        let texture = SKTexture.id(id, scale: scale)
        self.init(texture: texture)
        setScale(1 / scale.drawScale)
        self.position = position
        self.shadowedBitMask = 0xFFFFFFFF
    }

    func textureId(_ id: ImageIdentifier, scale: Artist.Scale = .Default) {
        if self.texture == nil {
            setScale(1 / scale.drawScale)
        }
        let texture = SKTexture.id(id, scale: scale)
        self.texture = texture
        size = texture.size() * xScale
    }
}

extension SKNode {
    var z: Z {
        set { zPosition = newValue.value }
        get { return .Custom(zPosition) }
    }

    var visible: Bool {
        get {
            if let parent = parent, !parent.visible {
                return false
            }
            return !isHidden && alpha > 0.1
        }
        set { isHidden = !newValue }
    }

    static func size(_ size: CGSize) -> SKNode {
        return SKSpriteNode(texture: nil, size: size)
    }

    func isParentOf(_ child: SKNode) -> Bool {
        return child.inParentHierarchy(self)
    }

    func rotateTo(_ angle: CGFloat) {
        zRotation = angle
    }

    func rotateTowards(_ node: SKNode) {
        let angle = angleTo(node)
        rotateTo(angle)
    }

    func rotateTowards(point: CGPoint) {
        let angle = (point - position).angle
        rotateTo(angle)
    }

    func distanceTo(_ node: SKNode) -> CGFloat {
        return sqrt(roughDistanceTo(node))
    }

    func roughDistanceTo(_ node: SKNode) -> CGFloat {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world, world.isParentOf(self), world.isParentOf(node) {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.roughDistanceTo(posNode)
        }
        let position = convertPosition(node)
        return position.roughLength
    }

    func distanceTo(_ node: SKNode, within radius: CGFloat) -> Bool {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world, world.isParentOf(self), world.isParentOf(node) {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return posSelf.distanceTo(posNode, within: radius)
        }
        let position = convertPosition(node)
        return position.lengthWithin(radius)
    }

    func angleTo(_ node: SKNode) -> CGFloat {
        let world = (self as? Node)?.world ?? (node as? Node)?.world
        if let world = world, world.isParentOf(self), world.isParentOf(node) {
            let posSelf = world.convertPosition(self)
            let posNode = world.convertPosition(node)
            return (posNode - posSelf).angle
        }
        let position = convertPosition(node)
        return position.angle
    }

    func convertPosition(_ node: SKNode) -> CGPoint {
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
            return convert(node.position, from: node.parent!)
        }
        else {
            return convert(.zero, from: node)
        }
    }

}
