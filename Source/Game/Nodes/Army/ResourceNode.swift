////
///  ResourceNode.swift
//

protocol ResourceWorld: class {
    func playerFoundResource(node: ResourceNode)
}

private let InitialDecay: CGFloat = 2

class ResourceNode: Node {
    var locked = false
    var decay = InitialDecay
    let sprite = SKSpriteNode()
    let goal: Int
    var remaining: Int {
        didSet {
            updateSprite()
        }
    }

    required init(goal: Int) {
        self.goal = goal
        self.remaining = goal
        super.init()
        self << sprite
        updateSprite()
        size = CGSize(30)
        keepRotating()
    }

    required convenience init() {
        self.init(goal: 30)
    }

    required init?(coder: NSCoder) {
        self.goal = coder.decodeInt(key: "goal") ?? 30
        self.remaining = coder.decodeInt(key: "remaining") ?? 30
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
        encoder.encode(goal, forKey: "goal")
        encoder.encode(remaining, forKey: "remaining")
    }

    func updateSprite() {
        if remaining <= 0 && get(component: ScaleToComponent.self) == nil {
            scaleTo(0, duration: 1, removeNode: true)
            fadeTo(0, duration: 0.9)
        }

        sprite.textureId(.Resource(goal: goal, remaining: max(remaining, 0)))
    }

    override func update(_ dt: CGFloat) {
        if locked {
            decay -= dt
            if decay <= 0 {
                5.times {
                    let node = ShrapnelNode(type: .ColorBox(size: CGSize(10), color: ResourceBlue), size: .Small)
                    node.setupAround(node: self)
                    world?.addChild(node)
                }
                remaining -= 1
                decay = InitialDecay
            }
        }
    }

    override func disableMovingComponents() {
        super.disableMovingComponents()
        get(component: KeepRotatingComponent.self)?.enabled = true
    }

}
