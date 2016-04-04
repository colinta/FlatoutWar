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
    var ui = UINode()
    var gameUI = UINode()
    var timeline = TimelineComponent()

    let cameraZoom = ScaleToComponent()
    let cameraMove = MoveToComponent()

    func moveCamera(to target: CGPoint? = nil, zoom: CGFloat? = nil, duration: CGFloat? = nil, rate: CGFloat? = nil, handler: MoveToComponent.OnArrived? = nil) {
        if let target = target {
            cameraMove.target = target
            if let duration = duration {
                cameraMove.duration = duration
            }
            else if let rate = rate {
                cameraMove.speed = rate
            }
            else {
                cameraMove.speed = 80
            }
            if let handler = handler {
                cameraMove.onArrived(handler)
            }
            cameraMove.resetOnArrived()
        }

        if let zoom = zoom {
            cameraZoom.target = zoom
            if let duration = duration {
                cameraZoom.duration = duration
            }
            else if let rate = rate {
                cameraZoom.rate = rate
            }
        }
    }

    func outsideWorld(angle angle: CGFloat) -> CGPoint {
        return outsideWorld(extra: 0, angle: angle)
    }

    func outsideWorld(node: Node, angle: CGFloat) -> CGPoint {
        return outsideWorld(extra: node.radius, angle: angle)
    }

    func outsideWorld(extra dist: CGFloat, angle _angle: CGFloat) -> CGPoint {
        let angle = normalizeAngle(_angle)
        let sizeAngle = size.angle

        let radius: CGFloat
        let offset: CGPoint
        if angle > TAU - sizeAngle || angle <= sizeAngle {
            // right side
            radius = size.width / 2 / cos(angle)
            offset = CGPoint(x: dist)
        }
        else if angle > TAU_2 + sizeAngle {
            // top
            radius = size.height / 2 / sin(angle)
            offset = CGPoint(y: -dist)
        }
        else if angle > TAU_2 - sizeAngle {
            // left side
            radius = size.width / 2 / cos(angle)
            offset = CGPoint(x: -dist)
        }
        else {
            // bottom
            radius = size.height / 2 / sin(angle)
            offset = CGPoint(y: dist)
        }

        var point = CGPoint(r: abs(radius), a: angle) + offset
        if let cameraNode = cameraNode {
            point += cameraNode.position
        }
        return point / min(xScale, 1)
    }

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

    func disablePlayers() { setPlayersEnabled(false) }
    func enablePlayers() { setPlayersEnabled(true) }
    private func setPlayersEnabled(enabled: Bool) {
        for player in players {
            player.frozen = !enabled
        }
    }

    required init() {
        super.init()

        let cameraNode = Node(at: CGPoint(x: 0, y: 0))
        self.cameraNode = cameraNode
        self << cameraNode

        cameraZoom.rate = 0.25
        addComponent(timeline)
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

    private func _populateWorld() {
        addComponent(cameraZoom)
        cameraNode!.addComponent(cameraMove)
    }

    func populateWorld() {
    }

    func restartWorld() {
        director?.presentWorld(self.dynamicType.init())
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
            return node.isEnemy
        }
        _cachedEnemies = cached
        return cached
    }

    private func cachedPlayers() -> [Node] {
        let cached = _cachedPlayers ?? nodes.filter { node in
            return node.isPlayer
        }
        _cachedPlayers = cached
        return cached
    }
}

extension World {

    // also called by addChild
    override func insertChild(node: SKNode, atIndex index: Int) {
        super.insertChild(node, atIndex: index)
        if let node = node as? Node {
            didAdd(node)

            _cachedNodes = nodes + [node]

            if node.isEnemy {
                _cachedEnemies = (_cachedEnemies ?? []) + [node]
            }

            if node.isPlayer {
                _cachedPlayers = (_cachedPlayers ?? []) + [node]
                reacquirePlayerTargets()
            }

            if node.fixedPosition != nil {
                updateFixedNodes()
            }
        }
    }

    func reacquirePlayerTargets() {
        for enemy in enemies {
            enemy.rammingComponent?.currentTarget = nil
            enemy.playerTargetingComponent?.currentTarget = nil
        }
    }

    func reacquireEnemyTargets() {
        for player in players {
            player.targetingComponent?.currentTarget = nil
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

    func didAdd(node: Node) {
    }

    func willRemove(node: Node) {
        if node === defaultNode {
            defaultNode = nil
        }
        if node === selectedNode {
            selectedNode = nil
        }
        if node === touchedNode {
            touchedNode = nil
        }
        resetCaches(isEnemy: node.isEnemy, isPlayer: node.isPlayer)
    }

}

extension World {

    func updateWorld(dtReal: CGFloat) {
        if !didPopulateWorld {
            _populateWorld()
            populateWorld()
            didPopulateWorld = true
            updateFixedNodes()
        }

        let hadEnemies = enemies.count > 0

        isUpdating = true
        shouldBePaused = worldPaused
        shouldBeHalted = halted

        if let cameraNode = cameraNode where cameraNode.world == nil {
            self << cameraNode
        }

        let dt = min(0.03, dtReal * timeRate)
        if !worldPaused {
            updateNodes(dt)
            gameUI.updateNodes(dt)

            throttleStragglers(dt: dt, clearStragglers)

            if enemies.count == 0 && hadEnemies {
                for handler in _onNoMoreEnemies {
                    handler()
                }
                _onNoMoreEnemies = []
            }
        }

        if !halted {
            ui.updateNodes(dt)

            if let cameraNode = cameraNode {
                position = -1 * cameraNode.position
            }
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
        let maxDistance = outerRadius * 2
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
        print("at time \(timeline.time)")
    }

    func worldTapped(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }
        guard !touchedNode.frozen else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.tapped(location)
    }

    func worldPressed(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }
        guard !touchedNode.frozen else { return }

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

        if let touchedNode = touchedNode where touchedNode.frozen {
            self.touchedNode = nil
            return
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
        let uiNodes: [Node]
        if worldPaused {
            uiNodes = [self.ui]
        }
        else {
            uiNodes = [self.ui, self.gameUI]
        }

        for uiNode in uiNodes {
            if let foundUi = touchableNodeAtLocation(worldLocation, inChildren: uiNode.children) {
                return foundUi
            }
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
            where !node.frozen && node.visible && touchableComponent.enabled {
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
            (scene as? WorldScene)?.worldPaused()
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
            (scene as? WorldScene)?.worldUnpaused()
            onUnpause()
        }
    }

}

extension World {

    func updateFixedNodes() {
        if screenSize != nil {
            var fixedNodes: [(Node, Position)] = []
            for uiNode in [ui, gameUI] {
                for sknode in uiNode.children {
                    if let node = sknode as? Node, fixedPosition = node.fixedPosition {
                        fixedNodes << (node, fixedPosition)
                    }
                }
            }

            for (node, fixedPosition) in fixedNodes {
                node.position = calculateFixedPosition(fixedPosition)
            }
        }
    }

    func updateFixedNode(node: Node) {
        if let fixedPosition = node.fixedPosition where screenSize != nil {
            node.position = calculateFixedPosition(fixedPosition)
        }
    }

    func calculateFixedPosition(position: Position) -> CGPoint {
        return position.positionIn(screenSize: screenSize ?? CGSize.zero)
    }

}
