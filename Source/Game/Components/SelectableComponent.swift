////
///  SelectableComponent.swift
//

class SelectableComponent: Component {
    var selected = false
    private var selecting = false

    typealias OnSelected = (Bool) -> Void
    typealias SimpleOnSelected = (Bool) -> Void
    var _onSelected: [OnSelected] = []

    override func reset() {
        super.reset()
        _onSelected = []
    }

    func bindTo(touchableComponent: TouchableComponent) {
        touchableComponent.on(.DownInside, onTouchIn)
        touchableComponent.on(.Pressed, onTouchPressed)
        touchableComponent.on(.Up, onTouchEnded)
    }

    func changeSelected(_ selected: Bool) {
        self.selected = selected
        for handler in _onSelected {
            handler(selected)
        }
    }

    func onSelected(_ handler: @escaping SimpleOnSelected) {
        _onSelected << { selected in handler(selected) }
    }

    func onTouchIn(_ location: CGPoint) {
        guard enabled else { return }

        if node.world?.selectedNode != node {
            node.world?.selectNode(node)
            selecting = true
        }
    }

    func onTouchPressed(_ location: CGPoint) {
        guard enabled else { return }

        if !selecting {
            node.world?.unselectNode(node)
        }
    }

    func onTouchEnded(_ location: CGPoint) {
        selecting = false
    }

}
