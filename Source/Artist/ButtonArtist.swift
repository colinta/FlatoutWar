//
//  ButtonArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension ButtonStyle {

    var name: String {
        switch self {
        case let .CircleSized(size):
            return "\(self)-size_\(size)"
        case let .SquareSized(size):
            return "\(self)-size_\(size)"
        case let .RectSized(width, height):
            return "\(self)-width_\(width)-height_\(height)"
        default: return "\(self)"
        }
    }
}

class ButtonArtist: TextArtist {
    var style: ButtonStyle = .None

    override func calculateSize() {
        super.calculateSize()

        switch style {
        case .Square:
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
    }

    override func draw(context: CGContext) {
        super.draw(context)

        CGContextSetLineWidth(context, 1)
        CGContextSetStrokeColorWithColor(context, color.CGColor)

        switch style {
        case .Square, .SquareSized, .RectSized:
            CGContextAddRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Stroke)
        case .Circle, .CircleSized:
            CGContextAddEllipseInRect(context, CGRect(size: size))
            CGContextDrawPath(context, .Stroke)
        case .None:
            break
        }
    }

}
