//
//  FollowComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/13/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class FollowComponent: Component {
    weak var follow: Node?

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
