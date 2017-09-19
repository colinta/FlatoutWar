////
///  EnemyBoatNode.swift
//

class EnemyBoatNode: Node {
    static let DefaultSpeed: CGFloat = 30

    enum Payload {
        case twoSoldiers

        var nodes: [EnemySoldierNode] {
            switch self {
            case .twoSoldiers: return [EnemySoldierNode(), EnemySoldierNode()]
            }
        }
    }

    let sprite = SKSpriteNode()
    fileprivate var payloadNodes: [EnemySoldierNode] = []

    convenience init(payload: Payload) {
        self.init()

        positionPayload(payload.nodes)
    }

    required init() {
        super.init()

        sprite.textureId(.enemyBoat)
        size = sprite.size
        self << sprite
        sprite.lightingBitMask   = 0xFFFFFFFF
        sprite.shadowCastBitMask = 0xFFFFFFFF
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    fileprivate func positionPayload(_ payloadNodes: [EnemySoldierNode]) {
        self.payloadNodes = payloadNodes

        let dx = size.width / CGFloat(payloadNodes.count)
        var x = -size.width / 2 + dx / 2
        for node in payloadNodes {
            node.sprite.lightingBitMask   = 0x0
            node.sprite.shadowCastBitMask = 0x0
            node.active = false
            node.position = CGPoint(x: x)
            x += dx
            self << node
        }
    }

    func deploy() {
        guard let world = self.world else { return }

        for node in payloadNodes {
            node.sprite.lightingBitMask   = 0xFFFFFFFF
            node.sprite.shadowCastBitMask = 0xFFFFFFFF

            node.move(toParent: world)
            node.active = true
            node.rotateTo(self.zRotation)
        }

        fadeTo(0, duration: 1.5, removeNode: true)
    }
}
