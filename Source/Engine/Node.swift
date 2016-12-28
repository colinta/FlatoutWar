////
///  Node.swift
//

class Node: SKNode {
    var active = true
    var interactive = true
    var timeRate: CGFloat = 1
    fileprivate var mods: [Mod] = []

    var fixedPosition: Position? {
        didSet {
            world?.updateFixedNode(self)
        }
    }
    var size: CGSize = .zero
    var radius: CGFloat {
        if size.width == size.height {
            return size.width / 2
        }
        return (size.width + size.height) / 4
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

    var shape: Shape = .Circle

    var components: [Component] = []
    struct WeakComponent {
        weak var value: Component?
        init(_ value: Component) {
            self.value = value
        }
    }
    fileprivate var componentsMapper: [String: WeakComponent] = [:]
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
        components = []
        componentsMapper = [:]
    }

    var draggableComponent: DraggableComponent? { return get(component: DraggableComponent.self) }
    var enemyComponent: EnemyComponent? { return get(component: EnemyComponent.self) }
    var firingComponent: FiringComponent? { return get(component: FiringComponent.self) }
    var healthComponent: HealthComponent? { return get(component: HealthComponent.self) }
    var moveToComponent: MoveToComponent? { return get(component: MoveToComponent.self) }
    var phaseComponent: PhaseComponent? { return get(component: PhaseComponent.self) }
    var playerComponent: PlayerComponent? { return get(component: PlayerComponent.self) }
    var playerTargetingComponent: PlayerTargetingComponent? { return get(component: PlayerTargetingComponent.self) }
    var projectileComponent: ProjectileComponent? { return get(component: ProjectileComponent.self) }
    var rammingComponent: RammingComponent? { return get(component: RammingComponent.self) }
    var rotateToComponent: RotateToComponent? { return get(component: RotateToComponent.self) }
    var selectableComponent: SelectableComponent? { return get(component: SelectableComponent.self) }
    var targetingComponent: EnemyTargetingComponent? { return get(component: EnemyTargetingComponent.self) }
    var touchableComponent: TouchableComponent? { return get(component: TouchableComponent.self) }

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

    func clone() -> Node {
        return type(of: self).init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        components = coder.decode(key: "components") ?? []
        active = coder.decodeBool(key: "active") ?? true
        size = coder.decodeSize(key: "size") ?? .zero
        if let z = coder.decodeCGFloat(key: "z") {
            self.z = Z(rawValue: z) ?? .Default
        }
        else {
            self.z = Z.Default
        }
        unarchiveComponents()
    }

    override func encode(with encoder: NSCoder) {
        encoder.encode(components, forKey: "components")
        encoder.encode(active, forKey: "active")
        encoder.encode(size, forKey: "size")
        encoder.encode(z.rawValue, forKey: "z")
        super.encode(with: encoder)
    }

    var autoReset = true
    override func move(toParent node: SKNode) {
        autoReset = false
        super.move(toParent: node)
        autoReset = true
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
        autoReset = reset
        removeFromParent()
        autoReset = true
    }

    override func removeFromParent() {
        if let world = world {
            world.willRemove([self] + allChildNodes())
        }
        if autoReset {
            for handler in _onDeath {
                handler()
            }
            reset()
        }
        super.removeFromParent()
    }

    func allChildNodes(recursive: Bool = true, interactive: Bool? = nil) -> [Node] {
        if let interactive = interactive, interactive != self.interactive {
            return []
        }

        let nodes: [Node] = children.flatMap { sknode in
            if let node = sknode as? Node, interactive == nil || node.interactive == interactive
            {
                return node
            }
            return nil
        }
        return nodes + (recursive ? nodes.flatMap { childNode in
            childNode.allChildNodes(interactive: interactive)
        } : [])
    }

}

// MARK: Update Cycle

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

    func update(_ dt: CGFloat) {
    }

}

// MARK: Positions and Angles

extension Node {

    override func rotateTo(_ angle: CGFloat) {
        super.rotateTo(angle)
        rotateToComponent?.currentAngle = angle
        rotateToComponent?.target = nil
    }

    func touchingLocation(_ node: Node) -> CGPoint? {
        if touches(node) {
            let a = self.angleTo(node)
            return CGPoint(r: radius, a: a)
        }
        return nil
    }

}

// MARK: Node Intersections

extension Node {

    func touches(_ other: Node) -> Bool {
        return shape.touchTest(self, and: other)
    }

    func touchableComponentFor(_: CGPoint) -> TouchableComponent? {
        return touchableComponent
    }

}

// MARK: Add/Remove Components

extension Node {

    func disableMovingComponents() {
        get(component: ArcToComponent.self)?.enabled = false
        get(component: FlyingComponent.self)?.enabled = false
        get(component: JiggleComponent.self)?.enabled = false
        get(component: KeepMovingComponent.self)?.enabled = false
        get(component: KeepRotatingComponent.self)?.enabled = false
        moveToComponent?.enabled = false
        rammingComponent?.enabled = false
        rotateToComponent?.enabled = false
        get(component: WanderingComponent.self)?.enabled = false
    }

    func get<T: Component>(component type: T.Type) -> T? {
        if let component = componentsMapper["\(type)"]?.value as? T {
            return component
        }
        for component in components {
            if let component = component as? T {
                componentsMapper["\(type)"] = WeakComponent(component)
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
            componentsMapper["\(type(of: component))"] = WeakComponent(component)
        }

        component.didAddToNode()
    }

    func removeComponent(_ component: Component) {
        if let index = components.index(of: component) {
            let type = "\(type(of: component))"
            if componentsMapper[type]?.value == component {
                componentsMapper[type] = nil
            }

            components.remove(at: index)
        }
    }

    fileprivate func unarchiveComponents() {
        fatalError("no support for addComponent(assign: false)")
    }

}

extension Node {

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
        return getAttr(.TimeRate).timeRate
    }

    func getAttr(_ attr: Attr) -> AttrMod {
        switch attr {
        case .Halted:
            for mod in mods {
                switch mod.attr {
                case let .Halted(halt):
                    if halt {
                        return .Halted(true)
                    }
                default: break
                }
            }
            return .Halted(false)
        case .TimeRate:
            var dt = timeRate
            for mod in mods {
                switch mod.attr {
                case let .TimeRate(rate):
                    dt *= rate
                default: break
                }
            }
            return .TimeRate(dt)
        }
    }

}
