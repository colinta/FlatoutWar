//
//  KeepMovingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class KeepMovingComponent: ApplyToNodeComponent {
    let velocity: CGPoint

    init(velocity: CGPoint) {
        self.velocity = velocity
        super.init()
    }

    required override init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) {
        velocity = coder.decodePoint("velocity") ?? .Zero
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func update(dt: CGFloat) {
        guard let applyTo = applyTo else {
            return
        }
        applyTo.position = applyTo.position + dt * velocity
    }

}
