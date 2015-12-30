//
//  PlayerComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class PlayerComponent: Component {
    enum Priority: IntValue {
        case High
        case Default
        case Low

        var int: Int {
            switch self {
            case High: return 3
            case Default: return 2
            case Low: return 1
            }
        }

    }

    var priority: Priority = .Default

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
    }

    override func update(dt: CGFloat, node: Node) {
    }

}
