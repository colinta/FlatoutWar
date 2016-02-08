//
//  PowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

let PowerupRed = 0xD92222

class PowerupArtist: Artist {
    var fillColor = UIColor(hex: 0x000000)
    var strokeColor = UIColor(hex: PowerupRed)

    required init() {
        super.init()
        size = CGSize(30)
    }

    override func draw(context: CGContext) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
    }

}
