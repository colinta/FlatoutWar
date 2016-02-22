//
//  MineFragmentArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/21/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class MineFragmentArtist: PowerupArtist {

    required init() {
        super.init()
        size = CGSize(5)
    }

    override func draw(context: CGContext) {
        super.draw(context)

        let d: CGFloat = 1.5
        let D: CGFloat = 2.5
        CGContextMoveToPoint(context, 0, middle.y + d)
        CGContextAddLineToPoint(context, size.width, middle.y + D)
        CGContextAddLineToPoint(context, size.width, middle.y - D)
        CGContextAddLineToPoint(context, 0, middle.y - d)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)
    }

}
