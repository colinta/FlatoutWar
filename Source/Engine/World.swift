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
    var cameraNode: Node
    var ui = UINode()
    var gameUI = UINode()
    var timeline = TimelineComponent()
    var interactionEnabled = true

    private var channel = ALChannelSource(sources: 32)

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

    let cameraZoom = ScaleToComponent()
    let cameraMove = MoveToComponent()

    enum Side {
        case Left
        case Right
        case Top
        case Bottom

        static func rand() -> Side {
            let side: Int = Int(arc4random_uniform(UInt32(4)))
            switch side {
                case 0: return .Left
                case 1: return .Right
                case 2: return .Top
                default: return .Bottom
            }
        }
    }

    func moveCamera(
        from start: CGPoint? = nil,
        to target: CGPoint? = nil,
        zoom: CGFloat? = nil,
        duration: CGFloat? = nil,
        rate: CGFloat? = nil,
        handler: MoveToComponent.OnArrived? = nil
    ) {
        if let start = start {
            cameraMove.node.position = start
        }

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
            cameraMove.onArrived {
                self.cameraMove.speed = nil
                self.cameraMove.duration = nil
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

    func randSideAngle(sides: [Side]) -> CGFloat {
        return randSideAngle(sides.rand())
    }

    func randSideAngle(side: Side? = nil) -> CGFloat {
        if let side = side {
            let spread: CGFloat
            switch side {
            case .Left, .Right:
                spread = atan2(size.height, size.width)
            case .Top, .Bottom:
                spread = atan2(size.width, size.height)
            }

            let angle: CGFloat
            switch side {
            case .Right:
                angle = 0
            case .Top:
                angle = TAU_4
            case .Left:
                angle = TAU_2
            case .Bottom:
                angle = TAU_3_4
            }

            return angle ± rand(spread)
        }
        else {
            return randSideAngle(rand() ? .Left : .Right)
        }
    }

    func outsideWorld(angle angle: CGFloat) -> CGPoint {
        return outsideWorld(extra: 0, angle: angle)
    }

    func outsideWorld(node: Node, angle: CGFloat) -> CGPoint {
        return outsideWorld(extra: node.radius, angle: angle)
    }

    func outsideWorld(extra dist: CGFloat, angle _angle: CGFloat, ui: Bool = false) -> CGPoint {
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
        if ui { return point }

        point += cameraNode.position
        return point / min(xScale, 1)
    }

    private var throttleStragglers = throttle(1)
    private var didPopulateWorld = false

    var director: WorldView? {
        return (scene as? WorldScene)?.view as? WorldView
    }

    var touchedNodes: [NSObject: (Node, TouchableComponent)] = [:]
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
            player.active = enabled
        }
    }

    required init() {
        self.cameraNode = Node(at: CGPoint(x: 0, y: 0))

        super.init()

        cameraZoom.rate = 0.25
        addComponent(timeline)
    }

    required init?(coder: NSCoder) {
        self.cameraNode = Node(at: CGPoint(x: 0, y: 0))

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
        cameraNode.addComponent(cameraMove)
    }

    func populateWorld() {
    }

    func restartWorld() {
        director?.presentWorld(self.dynamicType.init())
    }

}

extension World {

    private func resetCaches(isEnemy isEnemy: Bool = true, isPlayer: Bool = true) {
        _cachedNodes = nil
        if isEnemy {
            _cachedEnemies = nil
        }
        if isPlayer {
            _cachedPlayers = nil
        }
    }

    private func cachedNodes() -> [Node] {
        let cached = _cachedNodes ?? allChildNodes()
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
            processNewNode(node)
        }
    }

    func processNewNode(node: Node) {
        let newNodes = [node] + node.allChildNodes()
        for node in newNodes {
            didAdd(node)
        }

        _cachedNodes = nodes + newNodes
        var reacquire = false
        var fixedPositions = false
        for child in newNodes {
            if child.isEnemy {
                _cachedEnemies = (_cachedEnemies ?? []) + [child]
            }

            if child.isPlayer {
                _cachedPlayers = (_cachedPlayers ?? []) + [child]
                reacquire = true
            }

            if child.fixedPosition != nil {
                fixedPositions = true
            }
        }

        if reacquire {
            reacquirePlayerTargets()
        }

        if fixedPositions {
            updateFixedNodes()
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
        resetCaches()
    }

    override func removeChildrenInArray(nodes: [SKNode]) {
        super.removeChildrenInArray(nodes)
        resetCaches()
    }

    func didAdd(node: Node) {
    }

    func willRemove(nodes: [Node]) {
        var anyEnemy = false
        var anyPlayer = false
        for node in nodes {
            if node === defaultNode {
                defaultNode = nil
            }
            if node === selectedNode {
                selectedNode = nil
            }
            for (id, (touchedNode, _)) in touchedNodes {
                if node === touchedNode {
                    touchedNodes[id] = nil
                }
            }
            anyEnemy = anyEnemy || node.isEnemy
            anyPlayer = anyPlayer || node.isPlayer
        }
        resetCaches(isEnemy: anyEnemy, isPlayer: anyPlayer)
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

        if cameraNode.world == nil {
            self << cameraNode
        }

        let dt = min(0.03, dtReal)
        if !worldPaused {
            updateNodes(dt)
            gameUI.updateNodes(dt * timeRate)

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

            position = -1 * cameraNode.position
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

    func worldTapped(id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }
        guard touchedNode.active else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchableComponent.tapped(location)
    }

    func worldPressed(id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }
        guard touchedNode.active else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchableComponent.pressed(location)
    }

    func worldTouchBegan(id: NSObject, worldLocation: CGPoint) {
        if let touchedNode = touchableNodeAtLocation(worldLocation),
            touchableComponent = touchedNode.touchableComponentFor(convertPoint(worldLocation, toNode: touchedNode))
        where !(touchedNodes.any { (info) in return info.1.1 == touchableComponent })
        {
            touchedNodes[id] = (touchedNode, touchableComponent)
        }
        else if let currentNode = currentNode,
            touchableComponent = currentNode.touchableComponentFor(convertPoint(worldLocation, toNode: currentNode))
        where !(touchedNodes.any { (info) in return info.1.1 == touchableComponent })
        {
            touchedNodes[id] = (currentNode, touchableComponent)
        }

        if let (touchedNode, _) = touchedNodes[id] where !touchedNode.active {
            touchedNodes[id] = nil
            return
        }

        if let (touchedNode, touchableComponent) = touchedNodes[id] {
            let location = convertPoint(worldLocation, toNode: touchedNode)
            if !touchableComponent.shouldAcceptTouch(location) {
                if touchedNode == selectedNode {
                    selectedNode = nil
                }
                touchedNodes[id] = nil
            }
            else {
                touchableComponent.touchBegan(location)
            }
        }
    }

    func worldTouchEnded(id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchableComponent.touchEnded(location)

        touchedNodes[id] = nil
    }

    func worldDraggingBegan(id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchableComponent.draggingBegan(location)
    }

    func worldDraggingMoved(id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchableComponent.draggingMoved(location)
    }

    func worldDraggingEnded(id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchableComponent.draggingEnded(location)
    }

}

extension World {
    func touchableNodeAtLocation(worldLocation: CGPoint) -> Node? {
        guard interactionEnabled else { return nil }

        let uiNodes: [Node]
        if worldPaused {
            uiNodes = [self.ui]
        }
        else {
            uiNodes = [self.ui, self.gameUI]
        }

        for uiNode in uiNodes {
            if let foundUi = touchableNodeAtLocation(worldLocation, inChildren: uiNode.allChildNodes()) {
                return foundUi
            }
        }
        if !worldPaused {
            return touchableNodeAtLocation(worldLocation, inChildren: self.allChildNodes())
        }
        return nil
    }

    private func touchableNodeAtLocation(worldLocation: CGPoint, inChildren children: [Node]) -> Node? {
        for node in children.reverse() {
            guard node.touchableComponent != nil else { continue }

            let nodeLocation = convertPoint(worldLocation, toNode: node)
            if let touchableComponent = node.touchableComponentFor(nodeLocation)
            where node.active && node.visible && touchableComponent.enabled {
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
