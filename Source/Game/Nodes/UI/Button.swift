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
    var margins: UIEdgeInsets = UIEdgeInsetsZero

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
        touchableComponent.containsTouchTest = { [unowned self] (_, location) in
            return self.containsTouchTest(location)
        }
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

    override func updateTextNodes() {
        super.updateTextNodes()
        updateButtonStyle()
    }

    func containsTouchTest(location: CGPoint) -> Bool {
        let width = max(44, size.width)
        let height = max(44, size.height)

        var minX: CGFloat, maxX: CGFloat
        var minY = -height / 2
        var maxY = height / 2

        switch style {
        case .None:
            switch alignment {
            case .Left:
                minX = 0
                maxX = width
            case .Right:
                minX = -width
                maxX = 0
            default:
                minX = -width / 2
                maxX = width / 2
            }
        default:
            minX = -width / 2
            maxX = width / 2
        }

        minX -= margins.left
        maxX += margins.right
        minY -= margins.bottom
        maxY += margins.top

        return location.x >= minX && location.x <= maxX && abs(location.y) <= height / 2
    }

    private func updateButtonStyle() {
        switch style {
        case .None: break
        default:
            size = style.size
        }
        buttonStyleNode.textureId(.Button(style: style))
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
