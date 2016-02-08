//
//  BomberPowerupNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/5/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BomberPowerupNode: Node {

    required init() {
        super.init()
        size = CGSize(r: 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
