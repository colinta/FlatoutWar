//
//  KeepRotatingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/25/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class KeepRotatingComponent: ApplyToNodeComponent {
    var rate = CGFloat(1)

    override func update(dt: CGFloat) {
        guard let applyTo = applyTo else {
            return
        }
        applyTo.zRotation = applyTo.zRotation + dt * rate
    }

}
