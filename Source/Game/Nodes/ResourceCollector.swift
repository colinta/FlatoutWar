//
//  ResourceCollector.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/14/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ResourceCollector: Node {
    private weak var resourceNode: ResourceNode?
    private var initialPosition: CGPoint?
    weak var resourceLine: SKNode?

    let sprite = SKSpriteNode()
    var collecting = true {
        didSet {
            if collecting {
                sprite.textureId(.ColorCircle(size: CGSize(10), color: ResourceBlue))
            }
            else {
                sprite.textureId(.FillColorCircle(size: CGSize(10), color: ResourceBlue))
            }
        }
    }
    var harvesting: Bool {
        get { return !collecting }
        set { collecting = !newValue}
    }

    typealias OnHarvest = (Int) -> Void
    var _onHarvest: [OnHarvest] = []
    func onHarvest(handler: OnHarvest) { _onHarvest  << handler }

    required init(resource resourceNode: ResourceNode) {
        self.resourceNode = resourceNode
        super.init()
        sprite.textureId(.ColorCircle(size: CGSize(10), color: ResourceBlue))
        self << sprite
        size = sprite.size

        collect()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func reset() {
        super.reset()
        _onHarvest = []
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        if initialPosition == nil {
            initialPosition = position
        }

        if resourceNode?.remaining <= 0 && collecting {
            self.stopCollecting()
        }
    }

    func collect() {
        guard let resourceNode = resourceNode else { return }

        collecting = true
        moveToComponent?.removeFromNode()
        moveTo(resourceNode.position, speed: 20, removeComponent: false).onArrived {
            self.harvest()
        }
    }

    func harvest() {
        guard let resourceNode = resourceNode, initialPosition = initialPosition else {
            stopCollecting()
            return
        }

        let collected = min(resourceNode.remaining, 5)
        resourceNode.remaining -= collected

        harvesting = true
        moveToComponent?.removeFromNode()
        moveTo(initialPosition, speed: 20).onArrived {
            for handler in self._onHarvest {
                handler(collected)
            }

            if resourceNode.remaining > 0 {
                self.collect()
            }
            else {
                self.stopCollecting()
            }
        }
    }

    private func stopCollecting() {
        self.resourceLine?.runAction(
            SKAction.sequence([
                SKAction.fadeOutWithDuration(0.5),
                SKAction.removeFromParent(),
            ])
        )
        self.runAction(
            SKAction.sequence([
                SKAction.fadeOutWithDuration(0.5),
                SKAction.removeFromParent(),
            ])
        )
    }

}
