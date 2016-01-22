//
//  TextNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class TextNode: Node {
    var text: String {
        didSet { updateTextNodes() }
    }
    var font: ImageIdentifier.Size {
        didSet { updateTextNodes() }
    }
    var textSprite: SKNode
    var color: Int? {
        didSet { updateTextNodes() }
    }
    var alignment: NSTextAlignment = .Center {
        didSet { updateTextNodes() }
    }

    required init() {
        text = ""
        font = .Big
        textSprite = SKNode()
        super.init()
        z = .UI
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTextNodes() {
        textSprite.removeFromParent()
        textSprite = SKNode()

        let letterSpace: CGFloat
        switch font {
        case .Big: letterSpace = 3
        case .Small: letterSpace = 1
        }

        let sprites = text.characters.map { (char: Character) -> SKSpriteNode in
            if let color = self.color where color != 0xFFFFFF {
                return SKSpriteNode(id: .Letter(String(char), size: font, color: color))
            }
            else {
                return SKSpriteNode(id: .WhiteLetter(String(char), size: font))
            }
        }
        var first = true
        let size = sprites.reduce(CGSizeZero) { size, sprite in
            let width = size.width + sprite.size.width + (first ? 0 : letterSpace)
            let height = max(size.height, sprite.size.height)
            first = false
            return CGSize(width, height)
        }

        var x: CGFloat
        switch alignment {
            case .Left:
                x = 0
            case .Right:
                x = -size.width
            default:
                x = -size.width / 2
        }
        for sprite in sprites {
            x += sprite.size.width / 2
            sprite.position.x = x
            textSprite << sprite
            x += sprite.size.width / 2 + letterSpace
        }

        self << textSprite
        self.size = size
    }

}
