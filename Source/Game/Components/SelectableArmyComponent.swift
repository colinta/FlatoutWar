////
///  SelectableArmyComponent.swift
//

class SelectableArmyComponent: Component {
    var isSelected: Bool = false { didSet { updateComponents() }}
    var isMoving: Bool = false { didSet { updateComponents() }}
    var shootsWhileMoving: Bool = false { didSet { updateComponents() }}
    private(set) var armyEnabled: Bool = true
    private var isUpdatingComponents: Bool = false

    typealias OnUpdated = (Bool) -> Void
    private var _onUpdated: [OnUpdated] = []
    func onUpdated(_ handler: @escaping OnUpdated) { _onUpdated.append(handler) }

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
        if fadeRadar.applyTo == node {
            fadeRadar.applyTo = nil
        }
    }

    override func reset() {
        super.reset()
        fadeRadar.reset()
        _onUpdated = []
    }

    func updateComponents() {
        guard let node = node, !isUpdatingComponents else { return }
        isUpdatingComponents = true

        let died = node.healthComponent?.died ?? false
        let firingEnabled = (shootsWhileMoving || !isMoving) && !died
        let componentsEnabled = !isMoving && !died

        node.alpha = (firingEnabled || componentsEnabled) ? 1 : 0.5
        node.touchableComponent?.enabled = componentsEnabled
        node.playerComponent?.intersectable = firingEnabled
        node.firingComponent?.enabled = firingEnabled

        if !componentsEnabled {
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

        armyEnabled = componentsEnabled
        for handler in _onUpdated {
            handler(armyEnabled)
        }
        isUpdatingComponents = false
    }

}
