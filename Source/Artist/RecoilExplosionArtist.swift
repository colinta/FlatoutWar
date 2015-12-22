//
//  RecoilExplosionArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class RecoilExplosionArtist: Artist {
    var length = CGFloat(5)
    var time = CGFloat(0)
    var duration = CGFloat(1.5)
    var radius = CGFloat(25)
    let color = UIColor(hue: CGFloat(arc4random_uniform(256)) / 255.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var fade: CGFloat {
        if time > duration {
            return 1
        }
        else {
            return (duration - time) / duration
        }
    }

    override func draw(context: CGContext) {
        let currentLength: CGFloat
        if time < duration * CGFloat(0.75) {
            currentLength = length
        }
        else if time > duration {
            currentLength = 0
        }
        else {
            let ratio = time / duration
            let lR = -4 * ratio + 4.0
            currentLength = length * lR
        }
        let distance = time / duration * radius

        CGContextSetAlpha(context, fade)
        let lineWidth = 1.pixels
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        let numLines = 10
        for i in 0..<numLines {
            let angle = CGFloat(135.degrees + 90.degrees * CGFloat(i) / CGFloat(numLines))
            let p1 = CGPoint(r: distance, a: angle)
            let p2 = CGPoint(r: distance + currentLength, a: angle)
            CGContextMoveToPoint(context, p1.x, p1.y)
            CGContextAddLineToPoint(context, p2.x, p2.y)
        }
        CGContextDrawPath(context, .Stroke)
    }
}
