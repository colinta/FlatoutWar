//
//  WarningArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class WarningArtist: Artist {
    let fill = UIColor(hex: 0xFFFB28)
    let stroke = UIColor(hex: 0xD2081B)

    required init() {
        super.init()
        switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Pad:
                size = CGSize(20)
            default:
                size = CGSize(10)
        }
    }

    override func draw(context: CGContext) {
        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, fill.CGColor)
        CGContextSetStrokeColorWithColor(context, stroke.CGColor)

        let radius: CGFloat = 2
        let triRadius: CGFloat = size.height / 2 - radius

        let center = middle + CGPoint(y: radius / 2)
        let a = center + CGPoint(r: triRadius, a: TAU_3_4)
        let b = center + CGPoint(r: triRadius, a: TAU_12)
        let c = center + CGPoint(r: triRadius, a: 5 * TAU_12)

        let A = Segment(
            p1: a + CGPoint(r: 2 * radius, a: TAU_3_4),
            p2: a + CGPoint(r: radius, a: 11 * TAU_12)
            )
        let B = Segment(
            p1: b + CGPoint(r: 2 * radius, a: TAU_12),
            p2: b + CGPoint(r: radius, a: 3 * TAU_12)
            )
        let C = Segment(
            p1: c + CGPoint(r: 2 * radius, a: 5 * TAU_12),
            p2: c + CGPoint(r: radius, a: 7 * TAU_12)
            )
        CGContextMoveToPoint(context, C.p2.x, C.p2.y)
        CGContextAddArcToPoint(context, A.p1.x, A.p1.y, A.p2.x, A.p2.y, radius)
        CGContextAddArcToPoint(context, B.p1.x, B.p1.y, B.p2.x, B.p2.y, radius)
        CGContextAddArcToPoint(context, C.p1.x, C.p1.y, C.p2.x, C.p2.y, radius)
        CGContextClosePath(context)
        CGContextDrawPath(context, .Fill)

        let exHeight: CGFloat = 7
        let exDotHeight: CGFloat = 1
        let exOffset = exDotHeight / 2
        CGContextTranslateCTM(context, 0, -exOffset)
        CGContextMoveToPoint(context, center.x, center.y - exHeight / 2 )
        CGContextAddLineToPoint(context, center.x, center.y + exHeight / 2 - 2 * exDotHeight )
        CGContextMoveToPoint(context, center.x, center.y + exHeight / 2 - exDotHeight )
        CGContextAddLineToPoint(context, center.x, center.y + exHeight / 2 )
        CGContextDrawPath(context, .Stroke)
    }

}
