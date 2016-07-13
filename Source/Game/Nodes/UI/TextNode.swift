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
    var alignment: NSTextAlignment = .Center {
        didSet { updateTextNodes() }
    }
    var margins: UIEdgeInsets = UIEdgeInsetsZero

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTextNodes() {
        textSprite.removeAllChildren()

        let letterSpace = font.font.space
        let heightOffset = 2 * font.font.scale

        let sprites = text.characters.map { (char: Character) -> SKSpriteNode in
            if color == WhiteColor {
                return SKSpriteNode(id: .WhiteLetter(String(char), size: font))
            }
            else {
                return SKSpriteNode(id: .Letter(String(char), size: font, color: color))
            }
        }
        var first = true
        let size = sprites.reduce(CGSize.zero) { size, sprite in
            let width = size.width + sprite.size.width + (first ? 0 : letterSpace)
            let height = max(size.height, sprite.size.height - heightOffset)
            first = false
            return CGSize(width, height)
        }

        var x: CGFloat
        switch alignment {
            case .Left:
                x = margins.left
            case .Right:
                x = -size.width - margins.right
            default:
                x = -size.width / 2 + margins.left
        }
        for sprite in sprites {
            x += sprite.size.width / 2
            sprite.position.x = x
            sprite.position.y = -heightOffset / 2 - margins.top
            sprite.zPosition = zPosition
            textSprite << sprite
            x += sprite.size.width / 2 + letterSpace
        }

        self.textSize = size * textScale
        self.size = size
    }

}
