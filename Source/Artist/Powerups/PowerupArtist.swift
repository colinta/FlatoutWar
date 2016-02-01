//
//  PowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PowerupArtist: Artist {
    var fillColor = UIColor(hex: 0x000000)
    var strokeColor = UIColor(hex: 0xD92222)

    required init() {
        super.init()
        size = CGSize(30)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
    }

}
