//
//  ButtonArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let touchedMargin = CGFloat(1.5)

enum ButtonStyle {
    case Octagon
    case Square
    case Circle
    case None
}

class ButtonArtist: TextArtist {
    var style: ButtonStyle = .Octagon
    var touched = false {
        didSet { calculateSize() }
    }

    override func calculateSize() {
        super.calculateSize()

        switch style {
        case .Octagon, .Square:
            self.size.width += 10
            self.size.height += 8
        case .Circle:
            self.size.width = max(self.size.width, self.size.height)
            self.size.height = self.size.width
            self.size.width += 10
            self.size.height += 10
        default:
            break
        }

        if touched {
            self.size += CGSize(touchedMargin * 2)
        }
    }

    override func draw(context: CGContext) {
        super.draw(context)

        CGContextSetLineWidth(context, 1.pixels)
        CGContextSetStrokeColorWithColor(context, color.CGColor)

        switch style {
        case .Octagon:
            CGContextMoveToPoint(context, 5, 0)
            CGContextAddLineToPoint(context, 0, 4)
            CGContextAddLineToPoint(context, 0, size.height - 4)
            CGContextAddLineToPoint(context, 3.75, size.height - 1)
            CGContextAddLineToPoint(context, size.width - 3.75, size.height - 1)
            CGContextAddLineToPoint(context, 3.75, size.height - 1)
            CGContextAddLineToPoint(context, 5, size.height)
            CGContextAddLineToPoint(context, size.width - 5, size.height)
            CGContextAddLineToPoint(context, size.width, size.height - 4)
            CGContextAddLineToPoint(context, size.width, 4)
            CGContextAddLineToPoint(context, size.width - 5, 0)
            CGContextClosePath(context)
            CGContextDrawPath(context, .Stroke)
        case .Square:
            CGContextAddRect(context, CGRect(origin: CGPointZero, size: size))
            CGContextDrawPath(context, .Stroke)
        case .Circle:
            CGContextAddEllipseInRect(context, CGRect(origin: CGPointZero, size: size))
            CGContextDrawPath(context, .Stroke)
        case .None:
            break
        }
    }

}
