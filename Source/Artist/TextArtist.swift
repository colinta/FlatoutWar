////
///  TextArtist.swift
//

private let defaultLetter: (String, CGSize) -> Letter = { char, size in
    print("unknown char: \(char)")
    return Letter(style: .loop, size: size, points: [[
        CGPoint(0, 0),
        CGPoint(size.width, 0),
        CGPoint(size.width, size.height),
        CGPoint(0, size.height),
    ], [
        CGPoint(0, 0),
        CGPoint(size.width, size.height),
    ], [
        CGPoint(size.width, 0),
        CGPoint(0, size.height),
    ]])
}

class TextArtist: Artist {
    var text = "" { didSet { calculateSize() }}
    private var textSize: CGSize = .zero

    var color = UIColor(hex: WhiteColor)
    var font: Font = BigFont {
        didSet {
            calculateSize()
        }
    }
    private var textStroke: CGFloat { return font.stroke }
    private var textScale: CGFloat { return font.scale }
    private var letterSpace: CGFloat { return font.space }

    func calculateSize() {
        var size = CGSize(width: 0, height: 0)
        var isFirst = true
        for char in (text.characters.map { String($0) }) {
            let letter = font.art[char] ?? defaultLetter(char, font.size)
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

    override func draw(in context: CGContext) {
        context.setLineWidth(0.5)
        context.setStrokeColor(color.cgColor)
        context.setFillColor(color.cgColor)

        context.saveGState()
        context.scaleBy(x: textScale, y: textScale)
        context.translateBy(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2)
        for char in (text.characters.map { String($0) }) {
            let letter = font.art[char] ?? defaultLetter(char, font.size)
            for path in letter.points {
                var firstPoint = true
                for pt in path {
                    if firstPoint {
                        context.move(to: pt)
                        firstPoint = false
                    }
                    else {
                        context.addLine(to: pt)
                    }
                }

                if letter.style.closesPath {
                    context.closePath()
                }
            }

            context.drawPath(using: letter.style.drawPath)
            context.translateBy(x: letter.size.width + letterSpace, y: 0)
        }
        context.restoreGState()
    }

}
