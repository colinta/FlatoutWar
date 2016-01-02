//
//  ButtonNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ButtonNode: TextNode {
    var _onTapped: Block?
    func onTapped(handler: Block) { _onTapped = handler }

    override func reset() {
        super.reset()
        _onTapped = nil
    }

    required init() {
        super.init()

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest()
        touchableComponent.on(.Enter) { _ in
            self.highlight()
        }
        touchableComponent.on(.Exit) { _ in
            self.unhighlight()
        }
        touchableComponent.on(.UpInside) { location in
            self._onTapped?()
        }
        addComponent(touchableComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func highlight() {
        setScale(1.1)
    }

    private func unhighlight() {
        setScale(1)
    }

    override func update(dt: CGFloat) {
        touchableComponent?.enabled = self.enabled
    }

}
