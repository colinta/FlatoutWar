//
//  BomberPowerupNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/5/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let initialBombCount = 8

class BomberPowerupNode: Node {
    var numBombs = initialBombCount
    let sprite: SKSpriteNode = SKSpriteNode(id: .Bomber(numBombs: 8))
    let followPathComponent = FollowPathComponent()
    var bombs: [Node] = []
    override var timeRate: CGFloat {
        didSet {
            for node in bombs {
                node.timeRate = timeRate
            }
        }
    }

    required init() {
        super.init()
        size = CGSize(50)

        sprite.z = .Top
        self << sprite

        followPathComponent.velocity = 150
        addComponent(followPathComponent)

        let rotateComponent = RotateToComponent()
        rotateComponent.maxAngularSpeed = 15
        rotateComponent.angularAccel = nil
        addComponent(rotateComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func rotateTo(angle: CGFloat) {
        rotateToComponent?.target = angle
    }

    override func update(dt: CGFloat) {
        let timeChunk = followPathComponent.totalTime / (CGFloat(initialBombCount) - 1)
        let timeCheck = timeChunk * CGFloat(initialBombCount - numBombs)
        if followPathComponent.time >= timeCheck {
            dropBomb()
        }
    }

    private func dropBomb() {
        guard numBombs > 0 else { return }

        if let world = world {
            let bomb = BombNode(maxRadius: 60)
            bomb.position = self.position
            bomb.timeRate = timeRate
            bombs << bomb
            world << bomb

            numBombs -= 1
            sprite.textureId(.Bomber(numBombs: numBombs))
        }
    }

}
