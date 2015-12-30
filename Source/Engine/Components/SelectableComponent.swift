//
//  SelectableComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/28/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class SelectableComponent: Component {
    var selecting = false

    typealias OnSelected = (Node, Bool) -> Void
    typealias SimpleOnSelected = (Bool) -> Void
    var _onSelected = [OnSelected]()

    override func reset() {
        _onSelected = []
    }

    func bindTo(touchableComponent touchableComponent: TouchableComponent) {
        touchableComponent.on(.DownInside, onTouchIn)
        touchableComponent.on(.UpInside, onTouchOut)
        touchableComponent.on(.Up, onTouchEnded)
    }

    func changeSelected(node: Node, selected: Bool) {
        for handler in _onSelected {
            handler(node, selected)
        }
    }

    func onSelectedNode(handler: OnSelected) {
        _onSelected << handler
    }

    func onSelected(handler: SimpleOnSelected) {
        _onSelected << { _, selected in handler(selected) }
    }

    func onTouchIn(node: Node, location: CGPoint) {
        if node.world?.selectedNode != node {
            node.world?.selectNode(node)
            selecting = true
        }
    }

    func onTouchOut(node: Node, location: CGPoint) {
        if node.world?.selectedNode == node && !selecting {
            node.world?.unselectNode(node)
        }
    }

    func onTouchEnded(node: Node, location: CGPoint) {
        selecting = false
    }

    func selectedHandler(node: Node, selected: Bool) {
        for handler in _onSelected {
            handler(node, selected)
        }
    }

}
