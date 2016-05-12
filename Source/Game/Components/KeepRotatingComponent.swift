//
//  KeepRotatingComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/25/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class KeepRotatingComponent: ApplyToNodeComponent {
    var rate: CGFloat = 1

    override func update(dt: CGFloat) {
        apply { applyTo in
            applyTo.zRotation = applyTo.zRotation + dt * self.rate
        }
    }

}

extension Node {
    func keepRotating(rate: CGFloat? = nil) -> KeepRotatingComponent {
        let keepRotating = keepRotatingComponent ?? KeepRotatingComponent()
        if let rate = rate {
            keepRotating.rate = rate
        }
        if keepRotatingComponent == nil {
            self.addComponent(keepRotating)
        }
        return keepRotating
    }
}
