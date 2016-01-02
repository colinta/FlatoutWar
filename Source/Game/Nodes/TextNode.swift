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
    var alignment: NSTextAlignment

    required init() {
        text = ""
        font = .Big
        alignment = .Left
        super.init()
        z = .UI
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateTextNodes() {
        let newSprite = SKNode()
        let chars = text.characters.map { String($0) }
        let sprites = chars.map { return SKSpriteNode(id: .Letter(String($0), size: font)) }
        let size = sprites.reduce(CGSizeZero) { size, sprite in
            let width = size.width + sprite.size.width
            let height = max(size.height, sprite.size.height)
            return CGSize(width, height)
        }

        var x = -size.width / 2
        let letterSpace: CGFloat
        switch font {
        case .Big: letterSpace = 3
        case .Small: letterSpace = 1
        }

        for sprite in sprites {
            sprite.position.x = x
            newSprite << sprite
            x += sprite.size.width + letterSpace
        }

        self << newSprite
        self.size = size
    }

}
