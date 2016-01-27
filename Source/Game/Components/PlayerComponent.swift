//
//  PlayerComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

protocol PlayerNode: class {
}

class PlayerComponent: Component {
    var targetable: Bool = true
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == CGSizeZero {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func reset() {
        super.reset()
    }

    override func update(dt: CGFloat) {
    }

}
