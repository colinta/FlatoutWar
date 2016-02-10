//
//  ButtonArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

enum ButtonStyle {
    case Square
    case SquareSized(Int)
    case RectSized(Int, Int)
    case Circle
    case CircleSized(Int)
    case None

    var size: CGSize {
        switch self {
        case .Square: return CGSize(50)
        case .Circle: return CGSize(60)
        case let .SquareSized(size): return CGSize(CGFloat(size))
        case let .RectSized(width, height): return CGSize(CGFloat(width), CGFloat(height))
        case let .CircleSized(size): return CGSize(CGFloat(size))
        default: return .zero
        }
    }

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
            CGContextAddRect(context, CGRect(origin: .zero, size: size))
            CGContextDrawPath(context, .Stroke)
        case .Circle, .CircleSized:
            CGContextAddEllipseInRect(context, CGRect(origin: .zero, size: size))
            CGContextDrawPath(context, .Stroke)
        case .None:
            break
        }
    }

}
