//
//  TextArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

struct Letter: Equatable {
    enum Style {
        case Loop
        case Line
    }

    let style: Style
    let size: CGSize
    let points: [[CGPoint]]
}

func ==(lhs: Letter, rhs: Letter) -> Bool {
    if lhs.style == rhs.style && lhs.size == rhs.size && lhs.points.count == rhs.points.count {
        for (index, point) in lhs.points.enumerate() {
            if rhs.points[index] != point {
                return false
            }
        }
        return true
    }
    return false
}

typealias Font = [String: Letter]

class TextArtist: Artist {
    var text = "" { didSet { calculateSize() }}
    private var textSize = CGSizeZero
    var color = UIColor(hex: 0xFFFFFF)
    private var letterSpace = CGFloat(3)
    var font: Font = BigFont {
        didSet {
            if font == SmallFont {
                letterSpace = 1
            }
            else {
                letterSpace = 3
            }
            calculateSize()
        }
    }

    func calculateSize() {
        var size = CGSize(width: 0, height: 0)
        var isFirst = true
        for char in (text.unicodeScalars.map { String($0) }) {
            let letter = font[char] ?? (font[" "])!
            if !isFirst {
                size.width += letterSpace
            }
            isFirst = false
            size.width += letter.size.width
            size.height = max(letter.size.height, size.height)
        }
        self.size = size
        self.textSize = size
    }

    override func draw(context: CGContext) {
        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, color.CGColor)

        CGContextSaveGState(context)
        CGContextTranslateCTM(context, (size.width - textSize.width) / 2, (size.height - textSize.height) / 2)
        for char in (text.unicodeScalars.map { String($0) }) {
            let letter = font[char] ?? (font[" "])!
            for path in letter.points {
                var firstPoint = true
                for pt in path {
                    if firstPoint {
                        CGContextMoveToPoint(context, pt.x, pt.y)
                        firstPoint = false
                    }
                    else {
                        CGContextAddLineToPoint(context, pt.x, pt.y)
                    }
                }

                if letter.style == .Loop {
                    CGContextClosePath(context)
                }
            }
            CGContextDrawPath(context, .Stroke)
            CGContextTranslateCTM(context, letter.size.width + letterSpace, 0)
        }
        CGContextRestoreGState(context)
    }

}
