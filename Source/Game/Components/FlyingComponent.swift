//
//  FlyingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/6/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FlyingComponent: RammingComponent {

    required init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func moveTowards(dt: CGFloat, _ currentTargetLocation: CGPoint) {
    }

}
