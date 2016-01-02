//
//  World.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class World: Node {
    var timeline = TimelineComponent()
    var timeRate = CGFloat(1)
    private var throttleStragglers = throttle(1)
    private var didPopulateWorld = false

    var director: WorldView? {
        return (scene as? WorldScene)?.view as? WorldView
    }

    var worldRadius: CGFloat {
        if size.width == size.height {
            return size.width * 0.7071067811865476
        }
        return sqrt(pow(size.width, 2) + pow(size.height, 2)) / 2
    }

    var touchedNode: Node?
    var defaultNode: Node?
    var selectedNode: Node? {
        willSet {
            if let selectedNode = selectedNode
            where selectedNode != newValue {
                selectedNode.selectableComponent?.changeSelected(false)
            }
        }
        didSet {
            if let selectedNode = selectedNode {
                selectedNode.selectableComponent?.changeSelected(true)
            }
        }
    }

    private var _cachedNodes: [Node]?
    private var _cachedEnemies: [Node]?
    private var _cachedPlayers: [Node]?
    var nodes: [Node] { return cachedNodes() }
    var enemies: [Node] { return cachedEnemies() }
    var players: [Node] { return cachedPlayers() }

    required init() {
        super.init()
        self.addComponent(timeline)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        timeline = coder.decode("timeline") ?? timeline
        defaultNode = coder.decode("defaultNode")
    }

    override func encodeWithCoder(encoder: NSCoder) {
        encoder.encode(timeline, key: "timeline")
        encoder.encode(defaultNode, key: "defaultNode")
        super.encodeWithCoder(encoder)
    }

    func populateWorld() {
    }

}

extension World {

    private func resetCaches() {
        _cachedNodes = nil
        _cachedEnemies = nil
        _cachedPlayers = nil
    }

    private func cachedNodes() -> [Node] {
        let cached = _cachedNodes ?? children.filter { sknode in
            return sknode is Node
        } as! [Node]
        _cachedNodes = cached
        return cached
    }

    private func cachedEnemies() -> [Node] {
        let cached = _cachedEnemies ?? nodes.filter { node in
            return node.enemyComponent != nil
        }
        _cachedEnemies = cached
        return cached
    }

    private func cachedPlayers() -> [Node] {
        let cached = _cachedPlayers ?? nodes.filter { node in
            return node.playerComponent != nil
        }
        _cachedPlayers = cached
        return cached
    }
}

extension World {

    // called by addChild
    override func insertChild(node: SKNode, atIndex index: Int) {
        super.insertChild(node, atIndex: index)
        resetCaches()
    }

    override func removeAllChildren() {
        super.removeAllChildren()
        resetCaches()
    }

    override func removeChildrenInArray(nodes: [SKNode]) {
        super.removeChildrenInArray(nodes)
        resetCaches()
    }

    func willRemove(node: Node) {
        resetCaches()
    }

}

extension World {

    func updateWorld(dtReal: CGFloat) {
        if !didPopulateWorld {
            populateWorld()
            didPopulateWorld = true
        }

        let dt = min(0.03, dtReal * timeRate)
        updateNodes(dt)

        throttleStragglers(dt: dt, clearStragglers)
    }

    private func clearStragglers() {
        let maxDistance = radius * 1.5
        for node in allChildNodes() {
            if node.projectileComponent != nil && !convertPosition(node).lengthWithin(maxDistance) {
                node.removeFromParent()
            }
        }
    }

}

extension World {

    func selectNode(node: Node) {
        selectedNode = node
    }

    func unselectNode(node: Node) {
        if selectedNode == node {
            selectedNode = nil
        }
    }

}

extension World {

    func worldShook() {
    }

    func worldTapped(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.tapped(location)
    }

    func worldPressed(worldLocation: CGPoint, duration: CGFloat) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.pressed(location, duration: duration)
    }

    func worldTouchBegan(worldLocation: CGPoint) {
        if let touchedNode = touchableNodeAtLocation(worldLocation) {
            self.touchedNode = touchedNode
        }
        else {
            self.touchedNode = selectedNode ?? defaultNode
        }

        if let touchedNode = self.touchedNode {
            let location = convertPoint(worldLocation, toNode: touchedNode)

            if let shouldAcceptTest = touchedNode.touchableComponent?.shouldAcceptTouch(location)
            where !shouldAcceptTest {
                if touchedNode == selectedNode {
                    self.selectedNode = nil
                }
                self.touchedNode = nil
            }
            else {
                touchedNode.touchableComponent?.touchBegan(location)
            }
        }
    }

    func worldTouchEnded(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.touchEnded(location)

        self.touchedNode = nil
    }

    func worldDraggingBegan(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.draggingBegan(location)
    }

    func worldDraggingMoved(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.draggingMoved(location)
    }

    func worldDraggingEnded(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.draggingEnded(location)
    }

}

extension World {
    func touchableNodeAtLocation(worldLocation: CGPoint) -> Node? {
        for node in children.reverse() {
            if let node = node as? Node,
                touchableComponent = node.touchableComponent
            where node.enabled && node.visible {
                let nodeLocation = convertPoint(worldLocation, toNode: node)
                if touchableComponent.containsTouch(nodeLocation) {
                    return node
                }
            }
        }
        return nil
    }

}
