////
///  SelectableComponent.swift
//

class SelectableComponent: Component {
    var isCurrent = false
    var isSelected = false
    private var selecting = false

    typealias OnSelected = (Bool, Bool) -> Void
    var _onSelected: [OnSelected] = []

    override func reset() {
        super.reset()
        _onSelected = []
    }

    func bindTo(touchableComponent: TouchableComponent) {
        touchableComponent.on(.downInside, onTouchIn)
        touchableComponent.on(.pressed, onTouchPressed)
        touchableComponent.on(.up, onTouchEnded)
    }

    func changeSelected(isCurrent: Bool, isSelected: Bool) {
        guard isCurrent != self.isCurrent || isSelected != self.isSelected else { return }

        self.isCurrent = isCurrent
        self.isSelected = isSelected
        for handler in _onSelected {
            handler(isCurrent, isSelected)
        }
    }

    func onSelected(_ handler: @escaping OnSelected) {
        _onSelected << handler
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
