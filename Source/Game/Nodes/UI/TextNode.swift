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
    var font: ImageIdentifier.LetterSize {
        didSet { updateTextNodes() }
    }
    var textSprite: SKNode

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

        let chars = text.characters.map { String($0) }
        let sprites = chars.map { return SKSpriteNode(id: .Letter(String($0), size: font)) }
        var first = true
        let size = sprites.reduce(CGSizeZero) { size, sprite in
            let width = size.width + sprite.size.width + (first ? 0 : letterSpace)
            let height = max(size.height, sprite.size.height)
            first = false
            return CGSize(width, height)
        }

        var x = -size.width / 2
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
