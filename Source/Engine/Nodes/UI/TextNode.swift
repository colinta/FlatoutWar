////
///  TextNode.swift
//

class TextNode: Node {
    private(set) var textSize: CGSize = .zero
    var text: String {
        didSet { updateTextNodes() }
    }
    var font: ImageIdentifier.Size {
        didSet { updateTextNodes() }
    }
    var textSprite: SKNode
    var textScale: CGFloat {
        set {
            textSprite.setScale(newValue)
            updateTextNodes()
        }
        get { return textSprite.xScale }
    }
    var color: Int = WhiteColor {
        didSet { updateTextNodes() }
    }
    var alignment: NSTextAlignment = .center {
        didSet { updateTextNodes() }
    }
    var margins: UIEdgeInsets = .zero

    func calculateMargins() -> UIEdgeInsets {
        return self.margins
    }

    override var zPosition: CGFloat {
        didSet {
            for sprite in textSprite.children {
                sprite.zPosition = zPosition
            }
        }
    }

    required init() {
        text = ""
        font = .Small
        textSprite = SKNode()
        super.init()
        z = .UI
        self << textSprite
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateTextNodes() {
        textSprite.removeAllChildren()

        let lines: [String] = text.characters.split { $0 == "\n" }.map { String($0) }
        let verticalSpace: CGFloat = font.font.verticalSpace
        let letterSpace = font.font.space
        let heightOffset = 2 * font.font.scale

        let spriteCollection = lines.map { line in
            return line.characters.map { (char: Character) -> SKSpriteNode in
                if color == WhiteColor {
                    return SKSpriteNode(id: .WhiteLetter(String(char), size: font))
                }
                else {
                    return SKSpriteNode(id: .Letter(String(char), size: font, color: color))
                }
            }
        }

        let sizeCollection: [CGSize] = spriteCollection.map { sprites -> CGSize in
            var first = true
            return sprites.reduce(CGSize.zero) { size, sprite in
                let width = size.width + sprite.size.width + (first ? 0 : letterSpace)
                let height = max(size.height, sprite.size.height - heightOffset)
                first = false
                return CGSize(width, height)
            }
        }

        let size = sizeCollection.reduce(CGSize(height: verticalSpace * CGFloat(lines.count - 1))) { maxSize, size in
            return CGSize(
                width: max(maxSize.width, size.width),
                height: maxSize.height + size.height
                )
        }

        var y = size.height / 2
        for (index, sprites) in spriteCollection.enumerated() {
            let size = sizeCollection[index]
            y -= size.height / 2

            var x: CGFloat
            let margins = calculateMargins()
            switch alignment {
                case .left:
                    x = margins.left
                case .right:
                    x = -size.width - margins.right
                default:
                    x = -size.width / 2
            }
            for sprite in sprites {
                x += sprite.size.width / 2
                sprite.position.x = x
                sprite.position.y = y - heightOffset / 2
                sprite.zPosition = zPosition
                textSprite << sprite
                x += sprite.size.width / 2 + letterSpace
            }

            y -= verticalSpace
            y -= size.height / 2
        }
        
        self.textSize = size * textScale
        let marginsSize = CGSize(margins.left + margins.right, margins.top + margins.bottom)
        self.size = marginsSize + size
    }

}
