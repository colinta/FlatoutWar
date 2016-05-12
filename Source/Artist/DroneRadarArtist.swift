//
//  DroneRadarArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class DroneRadarArtist: Artist {
    var phase: CGFloat = 0
    var stroke = UIColor(hex: 0x25B1FF)
    var radarRadius: CGFloat?

    required init() {
        super.init()
        size = CGSize(20)
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        if let radarRadius = radarRadius where phase > 0.5 {
            CGContextSetLineWidth(context, 1)
            if phase < 0.9 {
                let phase1 = easeOutExpo(time: interpolate(phase, from: (0.5, 0.9), to: (0, 1)))
                let alpha1 = interpolate(phase, from: (0.6, 0.8), to: (0.25, 0))
                let drawingRadius = radarRadius * phase1
                CGContextSetAlpha(context, alpha1)
                CGContextAddEllipseInRect(context, middle.rect(size: CGSize(width: drawingRadius * 2, height: drawingRadius * 2)))
                CGContextDrawPath(context, .Stroke)
            }

            if phase > 0.6 {
                let phase2 = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
                let alpha2 = interpolate(phase, from: (0.8, 1.0), to: (0.25, 0))
                let drawingRadius = radarRadius * phase2
                CGContextSetAlpha(context, alpha2)
                CGContextAddEllipseInRect(context, middle.rect(size: CGSize(width: drawingRadius * 2, height: drawingRadius * 2)))
                CGContextDrawPath(context, .Stroke)
            }
        }
    }
}
