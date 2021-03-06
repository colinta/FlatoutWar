////
///  Node.swift
//

class Node: SKNode {
    var active = true
    var processedByWorld = false
    var interactive = true
    var timeRate: CGFloat = 1
    var autoReset = true
    fileprivate var mods: [Mod] = []

    var fixedPosition: Position? {
        didSet {
            world?.updateFixedNode(self)
        }
    }
    var size: CGSize = .zero
    var radius: CGFloat {
        return max(size.width, size.height) / 2
    }
    var innerRadius: CGFloat {
        if size.width == size.height {
            return size.width / 2
        }
        return min(size.width, size.height) / 2
    }
    var outerRadius: CGFloat {
        let outerRadius: CGFloat
        if size.width == size.height {
            outerRadius = size.width * 0.7071067811865476
        }
        else {
            outerRadius = sqrt(pow(size.width, 2) + pow(size.height, 2)) / 2
        }
        return outerRadius / xScale
    }

    var shape: Shape = .circle

    var components: [Component] = []
    fileprivate var assignedComponents: [Component] = []
    var world: World? { return (scene as? WorldScene)?.world }
    var parentNode: Node? { return parent as? Node }
    var isEnemy: Bool {
        return self.enemyComponent != nil
    }
    var isPlayer: Bool {
        return self.playerComponent != nil
    }
    var isProjectile: Bool {
        if let projectileComponent = projectileComponent {
            return projectileComponent.enabled
        }
        return false
    }

    typealias OnDeath = Block
    private var _onDeath: [OnDeath] = []
    func onDeath(_ handler: @escaping OnDeath) { _onDeath.append(handler) }

    func reset() {
        for component in components {
            component.reset()
        }
        for node in allChildNodes(recursive: false) {
            node.reset()
        }
        _onDeath = []
        processedByWorld = false
    }

    weak var draggableComponent: DraggableComponent?
    weak var enemyComponent: EnemyComponent?
    weak var enemyTargetingComponent: EnemyTargetingComponent?
    weak var followComponent: FollowComponent?
    weak var firingComponent: FiringComponent?
    weak var healthComponent: HealthComponent?
    weak var moveToComponent: MoveToComponent?
    weak var playerComponent: PlayerComponent?
    weak var playerTargetingComponent: PlayerTargetingComponent?
    weak var projectileComponent: ProjectileComponent?
    weak var rammingComponent: RammingComponent?
    weak var rotateToComponent: RotateToComponent?
    weak var selectableComponent: SelectableComponent?
    weak var touchableComponent: TouchableComponent?

    convenience init(at point: CGPoint) {
        self.init()
        position = point
    }

    convenience init(fixed position: Position) {
        self.init()
        fixedPosition = position
    }

    override required init() {
        super.init()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func clone() -> Node {
        return type(of: self).init()
    }

    func update(_ dt: CGFloat) {
    }

    override func setRotation(_ angle: CGFloat) {
        super.setRotation(angle)
        rotateToComponent?.target = nil
    }

    override func move(toParent node: SKNode) {
        let oldVal = autoReset
        autoReset = false
        super.move(toParent: node)
        autoReset = oldVal
    }

    func move(toParent node: SKNode, preservePosition: Bool) {
        if preservePosition {
            let p = node.convert(position, from: self.parent!)
            let wanderingComponent = get(component: WanderingComponent.self)
            move(toParent: node)
            position = p
            if let wanderingComponent = wanderingComponent,
                let wandering = wanderingComponent.centeredAround {
                wanderingComponent.centeredAround = wandering
            }
        }
        else {
            move(toParent: node)
        }
    }

    override func insertChild(_ node: SKNode, at index: Int) {
        super.insertChild(node, at: index)
        if let world = world, let node = node as? Node, world != self {
            world.processNewNode(node)
        }
    }

    func removeFromParent(reset: Bool) {
        let oldVal = autoReset
        autoReset = reset
        removeFromParent()
        autoReset = oldVal
    }

    override func removeFromParent() {
        if let world = world {
            world.willRemove([self] + allChildNodes(recursive: true))
        }

        if autoReset {
            for handler in _onDeath {
                handler()
            }
            reset()
        }

        super.removeFromParent()
    }

    func allChildNodes(recursive: Bool, interactive: Bool? = nil) -> [Node] {
        if let interactive = interactive, interactive != self.interactive {
            return []
        }

        let nodes: [Node] = children.compactMap { sknode in
            if let node = sknode as? Node, interactive == nil || node.interactive == interactive
            {
                return node
            }
            return nil
        }
        return nodes + (recursive ? nodes.flatMap { childNode in
            childNode.allChildNodes(recursive: true, interactive: interactive)
        } : [])
    }

}

extension Node {

    func levelCompleted() {
    }

    func updateNodes(_ dtReal: CGFloat) {
        guard active, world != nil, parent != nil else { return }

        let dt = dtReal * getTimeRate()

        for component in components {
            if component.enabled {
                component.update(dt)
            }
            if parent == nil { return }
        }
        update(dt)
        if parent == nil { return }

        for node in allChildNodes(recursive: false) {
            node.updateNodes(dt)
            if parent == nil { return }
        }
    }

}

extension Node {

    func touchingLocation(_ node: Node) -> CGPoint? {
        if touches(node) {
            let a = self.angleTo(node)
            return CGPoint(r: radius, a: a)
        }
        return nil
    }

}

extension Node {

    func touches(_ other: Node) -> Bool {
        return shape.touchTest(self, and: other)
    }

    func touchableComponentFor(_: CGPoint) -> TouchableComponent? {
        return touchableComponent
    }

}

extension Node {

    func disableMovingComponents() {
        get(component: ArcToComponent.self)?.enabled = false
        get(component: JiggleComponent.self)?.enabled = false
        get(component: KeepMovingComponent.self)?.enabled = false
        get(component: KeepRotatingComponent.self)?.enabled = false
        moveToComponent?.enabled = false
        rammingComponent?.enabled = false
        rotateToComponent?.enabled = false
        get(component: WanderingComponent.self)?.enabled = false
    }

    func get<T: Component>(component type: T.Type) -> T? {
        for component in assignedComponents {
            if let component = component as? T {
                return component
            }
        }
        return nil
    }

    func addComponent(_ component: Component, assign: Bool = true) {
        if let node = component.node {
            if node == self {
                return
            }
            else {
                component.removeFromNode()
            }
        }

        component.node = self
        components << component

        if assign {
            assignedComponents << component
            if let component = component as? DraggableComponent { draggableComponent = component }
            else if let component = component as? EnemyTargetingComponent { enemyTargetingComponent = component }
            else if let component = component as? EnemyComponent { enemyComponent = component }
            else if let component = component as? FiringComponent { firingComponent = component }
            else if let component = component as? FollowComponent { followComponent = component }
            else if let component = component as? HealthComponent { healthComponent = component }
            else if let component = component as? MoveToComponent { moveToComponent = component }
            else if let component = component as? PlayerComponent { playerComponent = component }
            else if let component = component as? PlayerTargetingComponent { playerTargetingComponent = component }
            else if let component = component as? ProjectileComponent { projectileComponent = component }
            else if let component = component as? RammingComponent { rammingComponent = component }
            else if let component = component as? RotateToComponent { rotateToComponent = component }
            else if let component = component as? SelectableComponent { selectableComponent = component }
            else if let component = component as? TouchableComponent { touchableComponent = component }
        }

        component.didAddToNode()
    }

    func removeComponent(_ component: Component) {
        if let index = components.firstIndex(of: component) {
            components.remove(at: index)

            if component == draggableComponent { draggableComponent = nil }
            else if component == enemyComponent { enemyComponent = nil }
            else if component == enemyTargetingComponent { enemyTargetingComponent = nil }
            else if component == firingComponent { firingComponent = nil }
            else if component == followComponent { followComponent = nil }
            else if component == healthComponent { healthComponent = nil }
            else if component == moveToComponent { moveToComponent = nil }
            else if component == playerComponent { playerComponent = nil }
            else if component == playerTargetingComponent { playerTargetingComponent = nil }
            else if component == projectileComponent { projectileComponent = nil }
            else if component == rammingComponent { rammingComponent = nil }
            else if component == rotateToComponent { rotateToComponent = nil }
            else if component == selectableComponent { selectableComponent = nil }
            else if component == touchableComponent { touchableComponent = nil }
        }

        if let index = assignedComponents.firstIndex(of: component) {
            assignedComponents.remove(at: index)
        }
    }

    fileprivate func unarchiveComponents() {
        fatalError("no support for addComponent(assign: false)")
    }

    @discardableResult
    func addMod(_ mod: Mod) -> NSUUID {
        if !mods.contains(mod) {
            mods << mod
        }
        return mod.id
    }

    func removeMod(_ mod: Mod) {
        removeMod(mod.id)
    }

    func removeMod(_ id: NSUUID) {
        for (index, mod) in mods.enumerated() {
            if mod.id == id {
                mods.remove(at: index)
                break
            }
        }
    }

    func getTimeRate() -> CGFloat {
        return getAttr(.timeRate).timeRate
    }

    func getAttr(_ attr: Attr) -> AttrMod {
        switch attr {
        case .halted:
            for mod in mods {
                switch mod.attr {
                case let .halted(halt):
                    if halt {
                        return .halted(true)
                    }
                default: break
                }
            }
            return .halted(false)
        case .timeRate:
            var dt = timeRate
            for mod in mods {
                switch mod.attr {
                case let .timeRate(rate):
                    dt *= rate
                default: break
                }
            }
            return .timeRate(dt)
        }
    }

}
