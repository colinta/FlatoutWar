//
//  TextArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TextArtist: Artist {
    var text = "" { didSet { calculateSize() }}
    var color = UIColor(hex: 0xFFFFFF)
    var font: Font = BigFont {
        didSet {
            if font == SmallFont {
                letterSpace = 1
                textScale = 3
            }
            else {
                letterSpace = 3
                textScale = 4
            }
            calculateSize()
        }
    }
    private var textScale: CGFloat = 4
    private var textSize: CGSize = .Zero
    private var letterSpace: CGFloat = 3

    func calculateSize() {
        var size = CGSize(width: 0, height: 0)
        var isFirst = true
        for char in (text.characters.map { String($0) }) {
            let letter = font[char] ?? (font[" "])!
            if !isFirst {
                size.width += letterSpace
            }
            isFirst = false
            size.width += letter.size.width
            size.height = max(letter.size.height, size.height)
        }
        size *= textScale
        self.size = size
        self.textSize = size
    }

    override func draw(context: CGContext) {
        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, color.CGColor)

        CGContextSaveGState(context)
        CGContextScaleCTM(context, textScale, textScale)
        CGContextTranslateCTM(context, (size.width - textSize.width) / 2, (size.height - textSize.height) / 2)
        for char in (text.characters.map { String($0) }) {
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
