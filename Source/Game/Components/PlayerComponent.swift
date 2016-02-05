//
//  PlayerComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class PlayerComponent: Component {
    enum Rammed {
        case Damaged
        case Attacks
    }

    var targetable: Bool = true
    var rammedBehavior: Rammed = .Damaged
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == .Zero {
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
