//
//  DroneRadarArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class DroneRadarArtist: Artist {
    var phase: CGFloat = 0
    var stroke = UIColor(hex: DroneColor)
    var radius: CGFloat

    required init(radius: CGFloat, phase: CGFloat) {
        self.radius = radius
        self.phase = phase
        super.init()
        size = CGSize(r: radius)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    override func draw(context: CGContext) {
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)
        if phase > 0.5 {
            CGContextSetLineWidth(context, 1)
            if phase < 0.9 {
                let phase1 = easeOutExpo(time: interpolate(phase, from: (0.5, 0.9), to: (0, 1)))
                let alpha1 = interpolate(phase, from: (0.6, 0.8), to: (0.25, 0))
                let drawingRadius = radius * phase1
                CGContextSetAlpha(context, alpha1)
                CGContextAddEllipseInRect(context, middle.rect(size: CGSize(width: drawingRadius * 2, height: drawingRadius * 2)))
                CGContextDrawPath(context, .Stroke)
            }

            if phase > 0.6 {
                let phase2 = easeOutExpo(time: interpolate(phase, from: (0.6, 1.0), to: (0, 1)))
                let alpha2 = interpolate(phase, from: (0.8, 1.0), to: (0.25, 0))
                let drawingRadius = radius * phase2
                CGContextSetAlpha(context, alpha2)
                CGContextAddEllipseInRect(context, middle.rect(size: CGSize(width: drawingRadius * 2, height: drawingRadius * 2)))
                CGContextDrawPath(context, .Stroke)
            }
        }
    }
}
