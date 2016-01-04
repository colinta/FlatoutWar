//
//  PercentBar.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PercentBar: Node {
    let sprite = SKSpriteNode(id: .Percent(0))
    var complete: CGFloat = 0 {
        didSet {
            sprite.textureId(.Percent(Int(round(complete * 100))))
        }
    }

    required init() {
        super.init()
        size = sprite.size
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func populate() {
        self << sprite
    }

}
