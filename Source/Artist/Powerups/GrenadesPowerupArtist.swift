//
//  GrenadePowerupArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class GrenadePowerupArtist: PowerupArtist {
    override func draw(context: CGContext) {
        super.draw(context)

        let pinSize = CGSize(5)
        let grenadeSize = size * 0.75
        let smallWidth: CGFloat = 6
        let bigWidth: CGFloat = 10
        let bigHeight: CGFloat = size.height - grenadeSize.height - pinSize.height / 2
        let smallHeight: CGFloat = bigHeight / 3
        let a: CGFloat = atan2(smallWidth / 2, grenadeSize.height / 2)
        CGContextTranslateCTM(context, size.width - grenadeSize.width / 2, size.height - grenadeSize.height / 2)
        CGContextMoveToPoint(context, -smallWidth / 2, -grenadeSize.height / 2)
        CGContextAddLineToPoint(context, -smallWidth / 2, -grenadeSize.height / 2 - smallHeight)

        let handleThickness: CGFloat = 2
        let handleLength: CGFloat = 6
        CGContextAddLineToPoint(context, -bigWidth + smallWidth / 2 + handleThickness, -grenadeSize.height / 2 - smallHeight)
        CGContextAddLineToPoint(context, -bigWidth + smallWidth / 2 + handleThickness - handleLength, -grenadeSize.height / 2 - smallHeight + handleLength)
        CGContextAddLineToPoint(context, -bigWidth + smallWidth / 2 - handleLength, -grenadeSize.height / 2 - smallHeight + handleLength - handleThickness)
        CGContextAddLineToPoint(context, -bigWidth + smallWidth / 2, -grenadeSize.height / 2 - smallHeight - handleThickness)

        CGContextAddLineToPoint(context, -bigWidth + smallWidth / 2, -grenadeSize.height / 2 - bigHeight)
        CGContextAddLineToPoint(context, smallWidth / 2, -grenadeSize.height / 2 - bigHeight)
        CGContextAddLineToPoint(context, smallWidth / 2, -grenadeSize.height / 2)
        CGContextAddArc(context, 0, 0, grenadeSize.width / 2, -TAU_4 + a, -TAU_4 - a, 0)
        CGContextClosePath(context)
        CGContextDrawPath(context, .FillStroke)

        let pinCenter = CGPoint(-bigWidth + smallWidth / 2, -grenadeSize.height / 2 - smallHeight - handleThickness)
        CGContextAddEllipseInRect(context, pinCenter.rectWithSize(pinSize))
        CGContextDrawPath(context, .Stroke)
    }

}
