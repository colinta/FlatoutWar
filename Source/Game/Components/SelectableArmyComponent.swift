////
///  SelectableArmyComponent.swift
//

class SelectableArmyComponent: Component {
    var isSelected: Bool = false { didSet { updateComponents() }}
    var isMoving: Bool = false { didSet { updateComponents() }}
    private(set) var armyEnabled: Bool = true

    private let fadeRadar = FadeToComponent()
    var cursorNode: CursorNode?
    var radarNode: SKNode? {
        get { return fadeRadar.applyTo }
        set { fadeRadar.applyTo = newValue }
    }

    override init() {
        super.init()
        fadeRadar.rate = 3.333
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddToNode() {
        super.didAddToNode()
        node.addComponent(fadeRadar, assign: false)
        updateComponents()
    }

    override func reset() {
        super.reset()
        fadeRadar.reset()
    }

    func updateComponents() {
        let died = node.healthComponent?.died ?? false
        self.armyEnabled = !isMoving && !died

        node.alpha = enabled ? 1 : 0.5
        node.touchableComponent?.enabled = enabled
        node.playerComponent?.intersectable = enabled
        node.firingComponent?.enabled = enabled

        if !enabled {
            node.world?.unselectNode(node)
        }

        cursorNode?.isSelected = isSelected

        if radarNode != nil {
            if isMoving || died {
                fadeRadar.target = 0
            }
            else if isSelected {
                fadeRadar.target = 1
            }
            else {
                fadeRadar.target = 0.75
            }
        }
    }

}
