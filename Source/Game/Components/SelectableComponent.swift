//
//  SelectableComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class SelectableComponent: Component {
    var selecting = false

    typealias OnSelected = (Bool) -> Void
    typealias SimpleOnSelected = (Bool) -> Void
    var _onSelected: [OnSelected] = []

    override func reset() {
        super.reset()
        _onSelected = []
    }

    func bindTo(touchableComponent touchableComponent: TouchableComponent) {
        touchableComponent.on(.DownInside, onTouchIn)
        touchableComponent.on(.UpInside, onTouchOut)
        touchableComponent.on(.Up, onTouchEnded)
    }

    func changeSelected(selected: Bool) {
        for handler in _onSelected {
            handler(selected)
        }
    }

    func onSelected(handler: SimpleOnSelected) {
        _onSelected << { selected in handler(selected) }
    }

    func onTouchIn(location: CGPoint) {
        guard enabled else { return }

        if node.world?.selectedNode != node {
            node.world?.selectNode(node)
            selecting = true
        }
    }

    func onTouchOut(location: CGPoint) {
        guard enabled else { return }

        if node.world?.selectedNode == node && !selecting {
            node.world?.unselectNode(node)
        }
    }

    func onTouchEnded(location: CGPoint) {
        selecting = false
    }

    func selectedHandler(selected: Bool) {
        for handler in _onSelected {
            handler(selected)
        }
    }

}
