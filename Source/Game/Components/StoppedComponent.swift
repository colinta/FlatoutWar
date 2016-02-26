//
//  StoppedComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/26/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class StoppedComponent: ApplyToNodeComponent {
    var start: CGPoint?

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

    override func didAddToNode() {
        super.didAddToNode()
        start = node.position
    }

    override func update(dt: CGFloat) {
        if let start = start {
            apply { applyTo in
                applyTo.position = start
            }
        }
    }

}
