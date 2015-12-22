//
//  CursorArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/26/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class CursorArtist: Artist {
    var selected = false {
        didSet { calculateSize() }
    }
    var color = UIColor(hex: 0x1158D9)

    required init() {
        super.init()
        calculateSize()
    }

    private func calculateSize() {
        size = selected ? CGSize(90) : CGSize(45)
    }

    override func draw(context: CGContext) {
        let lineWidth = CGFloat(2)
        let radius = middle.x - lineWidth / 2
        if selected {
            let numArcs = 18
            for i in 0..<numArcs {
                let a1 = CGFloat(2 * i) * TAU_2 / CGFloat(numArcs)
                let a2 = CGFloat(2 * i + 1) * TAU_2 / CGFloat(numArcs)
                let pt = CGPoint(r: radius, a: a1)
                CGContextMoveToPoint(context, middle.x + pt.x, middle.y + pt.y)
                CGContextAddArc(context, middle.x, middle.y, radius, a1, a2, 0)
            }
        }
        else {
            let origin = CGPoint(x: lineWidth / 2, y: lineWidth / 2)
            let size = self.size - CGSize(lineWidth)
            CGContextAddEllipseInRect(context, CGRect(origin: origin, size: size))
        }
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextDrawPath(context, .Stroke)
    }

    func addCircle(context: CGContext) {
        CGContextAddEllipseInRect(context, CGRect(origin: CGPointZero, size: size))
    }

    func addRect(context: CGContext) {
        CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
    }

}
