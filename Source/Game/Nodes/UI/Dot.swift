//
//  Dot.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/14/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Dot: Node {

    required init() {
        super.init()
        self << SKShapeNode(circleOfRadius: 3)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
