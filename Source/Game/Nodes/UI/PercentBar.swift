//
//  PercentBar.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PercentBar: Node {
    let sprite = SKSpriteNode(id: .Percent(0, style: .Default))
    var style: PercentStyle = .Default { didSet { updateSprite() } }
    var complete: CGFloat = 0 { didSet {
        if complete > 1 { complete = 1 }
        else if complete < 0 { complete = 0 }
        else {
            updateSprite()
        }
    } }

    private func updateSprite() {
        sprite.textureId(.Percent(Int(round(complete * 100)), style: style))
        size = sprite.size
    }

    required init() {
        super.init()
        self << sprite
        updateSprite()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
