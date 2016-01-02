//
//  Node.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Node: SKNode {
    enum Z: CGFloat {
        case UITop = 8
        case UI = 7
        case UIBottom = 6
        case Top = 5
        case Above = 2
        case Default = 0
        case Below = -2
        case Bottom = -4
    }

    var enabled = true
    var z: Z = .Default {
        didSet { zPosition = z.rawValue }
    }
    var visible: Bool {
        get { return !hidden }
        set { hidden = !visible }
    }
    var components: [Component] = []
    var world: World? { return (scene as? WorldScene)?.world }
    var size = CGSizeZero
    var radius: CGFloat {
        if size.width == size.height {
            return size.width / 2
        }
        return (size.width + size.height) / 4
    }

    typealias OnDeath = Block
    private var _onDeath = [OnDeath]()
    func onDeath(handler: OnDeath) { _onDeath << handler }

    func populate() {
    }

    func reset() {
        for component in components {
            component.reset()
        }
        _onDeath = []
    }

    func update(dt: CGFloat) {
    }

    override func removeFromParent() {
        if let world = world {
            world.willRemove(self)
            for handler in _onDeath {
                handler()
            }
            reset()
        }
        super.removeFromParent()
    }

    func allChildNodes() -> [Node] {
        let nodes = children.filter { sknode in
            return sknode is Node
        } as! [Node]
        return nodes + nodes.flatMap { childNode in
            childNode.allChildNodes()
        }
    }

    weak var draggableComponent: DraggableComponent?
    weak var enemyComponent: EnemyComponent?
    weak var fadeToComponent: FadeToComponent?
    weak var firingComponent: FiringComponent?
    weak var followNodeComponent: FollowNodeComponent?
    weak var growToComponent: GrowToComponent?
    weak var healthComponent: HealthComponent?
    weak var keepMovingComponent: KeepMovingComponent?
    weak var keepRotatingComponent: KeepRotatingComponent?
    weak var moveToComponent: MoveToComponent?
    weak var phaseComponent: PhaseComponent?
    weak var playerComponent: PlayerComponent?
    weak var projectileComponent: ProjectileComponent?
    weak var rammableComponent: RammableComponent?
    weak var rammingComponent: RammingComponent?
    weak var rotateToComponent: RotateToComponent?
    weak var selectableComponent: SelectableComponent?
    weak var targetingComponent: TargetingComponent?
    weak var timelineComponent: TimelineComponent?
    weak var touchableComponent: TouchableComponent?
    weak var wanderingComponent: WanderingComponent?

    convenience init(at point: CGPoint) {
        self.init()
        position = point
    }

    override required init() {
        super.init()
        populate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        components = coder.decode("components") ?? []
        enabled = coder.decodeBool("enabled") ?? true
        size = coder.decodeSize("size") ?? CGSizeZero
        if let z = coder.decodeCGFloat("z") {
            self.z = Z(rawValue: z) ?? .Default
        }
        else {
            self.z = Z.Default
        }
        unarchiveComponents()
    }

    override func encodeWithCoder(encoder: NSCoder) {
        encoder.encode(components, key: "components")
        encoder.encode(enabled, key: "enabled")
        encoder.encode(size, key: "size")
        encoder.encode(z.rawValue, key: "z")
        super.encodeWithCoder(encoder)
    }

}

// MARK: Update Cycle

extension Node {

    func updateNodes(dt: CGFloat) {
        for component in components {
            if component.enabled {
                component.update(dt)
            }
        }
        update(dt)
        for sknode in children {
            if let node = sknode as? Node {
                node.updateNodes(dt)
            }
        }
    }

}

// MARK: Positions and Angles

extension Node {

    func distanceTo(node: Node) -> CGFloat {
        let position = convertPoint(node.position, fromNode: node.parent!)
        return position.length
    }

    func distanceTo(node: Node, within radius: CGFloat) -> Bool {
        let position = convertPoint(node.position, fromNode: node.parent!)
        return position.lengthWithin(radius)
    }

    func angleTo(node: Node) -> CGFloat {
        let position = convertPoint(node.position, fromNode: node.parent!)
        return position.angle
    }

    func rotateTowards(node: Node) {
        let angle = angleTo(node)
        zRotation = angle
        rotateToComponent?.destAngle = angle
    }

    func touchingLocation(node: Node) -> CGPoint? {
        if touches(node) {
            let a = self.angleTo(node)
            return CGPoint(r: radius, a: a)
        }
        return nil
    }

}

// MARK: Node Intersections

extension Node {

    func touches(other: Node) -> Bool {
        let radius = max(0.01, other.radius + self.radius)
        if distanceTo(other, within: radius) {
            return true
        }
        return false
    }

}

// MARK: Add/Remove Components

extension Node {

    func addComponent(component: Component) {
        component.node = self
        components << component

        if let component = component as? DraggableComponent { draggableComponent = component }
        else if let component = component as? EnemyComponent { enemyComponent = component }
        else if let component = component as? FadeToComponent { fadeToComponent = component }
        else if let component = component as? FiringComponent { firingComponent = component }
        else if let component = component as? FollowNodeComponent { followNodeComponent = component }
        else if let component = component as? GrowToComponent { growToComponent = component }
        else if let component = component as? HealthComponent { healthComponent = component }
        else if let component = component as? KeepMovingComponent { keepMovingComponent = component }
        else if let component = component as? KeepRotatingComponent { keepRotatingComponent = component }
        else if let component = component as? MoveToComponent { moveToComponent = component }
        else if let component = component as? PhaseComponent { phaseComponent = component }
        else if let component = component as? PlayerComponent { playerComponent = component }
        else if let component = component as? ProjectileComponent { projectileComponent = component }
        else if let component = component as? RammableComponent { rammableComponent = component }
        else if let component = component as? RammingComponent { rammingComponent = component }
        else if let component = component as? RotateToComponent { rotateToComponent = component }
        else if let component = component as? SelectableComponent { selectableComponent = component }
        else if let component = component as? TargetingComponent { targetingComponent = component }
        else if let component = component as? TimelineComponent { timelineComponent = component }
        else if let component = component as? TouchableComponent { touchableComponent = component }
        else if let component = component as? WanderingComponent { wanderingComponent = component }
    }

    func removeComponent(component: Component) {
        if let index = components.indexOf(component) {
            if component == draggableComponent { draggableComponent = nil }
            else if component == enemyComponent { enemyComponent = nil }
            else if component == fadeToComponent { fadeToComponent = nil }
            else if component == firingComponent { firingComponent = nil }
            else if component == followNodeComponent { followNodeComponent = nil }
            else if component == growToComponent { growToComponent = nil }
            else if component == healthComponent { healthComponent = nil }
            else if component == keepMovingComponent { keepMovingComponent = nil }
            else if component == keepRotatingComponent { keepRotatingComponent = nil }
            else if component == moveToComponent { moveToComponent = nil }
            else if component == phaseComponent { phaseComponent = nil }
            else if component == playerComponent { playerComponent = nil }
            else if component == projectileComponent { projectileComponent = nil }
            else if component == rammableComponent { rammableComponent = nil }
            else if component == rammingComponent { rammingComponent = nil }
            else if component == rotateToComponent { rotateToComponent = nil }
            else if component == selectableComponent { selectableComponent = nil }
            else if component == targetingComponent { targetingComponent = nil }
            else if component == timelineComponent { timelineComponent = nil }
            else if component == touchableComponent { touchableComponent = nil }
            else if component == wanderingComponent { wanderingComponent = nil }

            components.removeAtIndex(index)
        }
    }

    private func unarchiveComponents() {
        for component in components {
            if let component = component as? DraggableComponent { draggableComponent = component }
            else if let component = component as? EnemyComponent { enemyComponent = component }
            else if let component = component as? FadeToComponent { fadeToComponent = component }
            else if let component = component as? FiringComponent { firingComponent = component }
            else if let component = component as? FollowNodeComponent { followNodeComponent = component }
            else if let component = component as? GrowToComponent { growToComponent = component }
            else if let component = component as? HealthComponent { healthComponent = component }
            else if let component = component as? KeepMovingComponent { keepMovingComponent = component }
            else if let component = component as? KeepRotatingComponent { keepRotatingComponent = component }
            else if let component = component as? MoveToComponent { moveToComponent = component }
            else if let component = component as? PhaseComponent { phaseComponent = component }
            else if let component = component as? PlayerComponent { playerComponent = component }
            else if let component = component as? ProjectileComponent { projectileComponent = component }
            else if let component = component as? RammableComponent { rammableComponent = component }
            else if let component = component as? RammingComponent { rammingComponent = component }
            else if let component = component as? RotateToComponent { rotateToComponent = component }
            else if let component = component as? SelectableComponent { selectableComponent = component }
            else if let component = component as? TargetingComponent { targetingComponent = component }
            else if let component = component as? TimelineComponent { timelineComponent = component }
            else if let component = component as? TouchableComponent { touchableComponent = component }
            else if let component = component as? WanderingComponent { wanderingComponent = component }
        }
    }

}
