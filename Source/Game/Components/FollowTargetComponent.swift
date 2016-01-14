//
//  FollowTargetComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FollowTargetComponent: FollowComponent {

    override func update(dt: CGFloat) {
        guard let follow = follow else { return }

        if let comp = node.rammingComponent {
            comp.tempTarget = follow.position
        }
    }

}
