//
//  Button.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Button: TextNode {
    var style: ButtonStyle = .None {
        didSet { updateButtonStyle() }
    }
    var preferredScale: CGFloat = 1

    private var buttonStyleNode: SKSpriteNode!
    var enabled = true {
        didSet {
            alpha = enabled ? 1 : 0.25
        }
    }

    typealias OnTapped = Block
    var _onTapped: OnTapped?
    func onTapped(handler: OnTapped) { _onTapped = handler }
    func offTapped() { _onTapped = nil }

    override func setScale(scale: CGFloat) {
        preferredScale = scale
        super.setScale(scale)
    }

    override func reset() {
        super.reset()
        _onTapped = nil
    }

    required init() {
        super.init()

        buttonStyleNode = SKSpriteNode(id: .None)
        self << buttonStyleNode

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest()
        touchableComponent.on(.Enter) { _ in
            self.highlight()
        }
        touchableComponent.on(.Exit) { _ in
            self.unhighlight()
        }
        touchableComponent.on(.UpInside) { _ in
            self._onTapped?()
        }
        addComponent(touchableComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateButtonStyle() {
        switch style {
        case .Square, .SquareSized, .Circle, .CircleSized, .RectSized:
            size = style.size
        default: break
        }
        buttonStyleNode.textureId(.Button(style: style))
    }

    override func updateTextNodes() {
        super.updateTextNodes()
        updateButtonStyle()
    }

    private func highlight() {
        super.setScale(preferredScale * 1.1)
    }

    private func unhighlight() {
        super.setScale(preferredScale)
    }

    override func update(dt: CGFloat) {
        touchableComponent?.enabled = self.enabled
    }

}
