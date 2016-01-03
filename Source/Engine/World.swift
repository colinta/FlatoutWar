//
//  World.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class World: Node {
    var screenSize: CGSize! {
        didSet {
            updateFixedNodes()
        }
    }
    var cameraNode: Node?
    var ui: Node! { return (scene as? WorldScene)?.uiNode }
    var timeline = TimelineComponent()
    var timeRate: CGFloat = 1

    var pauseable = true
    private var shouldBePaused = false
    private var shouldBeHalted = false
    var isUpdating = false
    private var _halted = false
    var halted: Bool {
        get { return _halted }
        set(halt) {
            if halt {
                self.halt()
            }
            else {
                self.resume()
            }
        }
    }

    private var _paused = false
    var worldPaused: Bool {
        get { return _paused || _halted }
        set(pause) {
            if pause {
                self.pause()
            }
            else {
                self.unpause()
            }
        }
    }

    private var throttleStragglers = throttle(1)
    private var didPopulateWorld = false

    var director: WorldView? {
        return (scene as? WorldScene)?.view as? WorldView
    }

    var touchedNode: Node?
    var currentNode: Node? { return selectedNode ?? defaultNode }
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

    typealias OnNoMoreEnemies = Block
    private var _onNoMoreEnemies = [OnNoMoreEnemies]()
    func onNoMoreEnemies(handler: OnNoMoreEnemies) {
        if enemies.count == 0 {
            handler()
        }
        _onNoMoreEnemies << handler
    }

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

    override func reset() {
        super.reset()
        _onNoMoreEnemies = []
    }

    func populateWorld() {
    }

}

extension World {

    private func resetCaches(isEnemy isEnemy: Bool, isPlayer: Bool) {
        _cachedNodes = nil
        if isEnemy {
            _cachedEnemies = nil
        }
        if isPlayer {
            _cachedPlayers = nil
        }
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
        if let node = node as? Node {
            willAdd(node)
            resetCaches(isEnemy: node.isEnemy ?? false, isPlayer: node.isPlayer ?? false)
            if node.fixedPosition != nil {
                updateFixedNodes()
            }
        }
    }

    override func removeAllChildren() {
        super.removeAllChildren()
        resetCaches(isEnemy: true, isPlayer: true)
    }

    override func removeChildrenInArray(nodes: [SKNode]) {
        super.removeChildrenInArray(nodes)
        resetCaches(isEnemy: true, isPlayer: true)
    }

    func willAdd(node: Node) {
    }

    func willRemove(node: Node) {
        resetCaches(isEnemy: node.isEnemy, isPlayer: node.isPlayer)
    }

}

extension World {

    func updateWorld(dtReal: CGFloat) {
        if !didPopulateWorld {
            populateWorld()
            didPopulateWorld = true
            updateFixedNodes()
        }

        let hadEnemies = enemies.count > 0

        isUpdating = true
        shouldBePaused = worldPaused
        shouldBeHalted = halted

        let dt = min(0.03, dtReal * timeRate)
        if !worldPaused {
            updateNodes(dt)

            if enemies.count == 0 && hadEnemies {
                for handler in _onNoMoreEnemies {
                    handler()
                }
            }
        }

        if !halted {
            ui.updateNodes(dt)

            if let cameraNode = cameraNode {
                position = -1 * cameraNode.position
            }

            throttleStragglers(dt: dt, clearStragglers)
        }

        isUpdating = false

        if shouldBePaused != worldPaused {
            worldPaused = shouldBePaused
        }
        if shouldBeHalted != halted {
            halted = shouldBeHalted
        }
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

    func worldPressed(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.pressed(location)
    }

    func worldTouchBegan(worldLocation: CGPoint) {
        if let touchedNode = touchableNodeAtLocation(worldLocation) {
            self.touchedNode = touchedNode
        }
        else {
            self.touchedNode = currentNode
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
        if let foundUi = touchableNodeAtLocation(worldLocation, inChildren: self.ui.children) {
            return foundUi
        }
        if !worldPaused {
            return touchableNodeAtLocation(worldLocation, inChildren: self.children)
        }
        return nil
    }

    private func touchableNodeAtLocation(worldLocation: CGPoint, inChildren children: [SKNode]) -> Node? {
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

extension World {

    func onHalt() {}
    final func halt() {
        pause()
        if isUpdating {
            shouldBeHalted = true
        }
        else if !_halted {
            _halted = true
            onHalt()
        }
    }

    func onResume() {}
    final func resume() {
        if isUpdating {
            shouldBeHalted = false
        }
        else if _halted {
            onResume()
            _halted = false
        }
    }

    func onPause() {}
    final func pause() {
        guard pauseable else { return }

        if isUpdating {
            shouldBePaused = true
        }
        else if !_paused {
            _paused = true
            onPause()
        }
    }

    func onUnpause() {}
    final func unpause() {
        guard !_halted else { return }

        if isUpdating {
            shouldBePaused = false
        }
        else if _paused {
            _paused = false
            onUnpause()
        }
    }

}

extension World {

    func updateFixedNodes() {
        if let screenSize = screenSize, ui = ui {
            let uiNodes = ui.children.filter { sknode in
                return (sknode as? Node)?.fixedPosition != nil
            } as! [Node]

            for node in uiNodes {
                node.position = node.fixedPosition!.positionIn(screenSize: screenSize)
            }
        }
    }

    func updateFixedNode(node: Node) {
        if let screenSize = screenSize, fixedPosition = node.fixedPosition {
            node.position = fixedPosition.positionIn(screenSize: screenSize)
        }
    }

}
