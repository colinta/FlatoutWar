////
///  World.swift
//

class World: Node {
    var screenSize: CGSize = .zero {
        didSet {
            updateFixedNodes()
        }
    }
    var cameraNode: Node
    var ui = UINode()
    var gameUI = UINode()
    var timeline = TimelineComponent()
    var interactionEnabled = true
    var channel = ALChannelSource(sources: 32)

    var multitouchEnabled = false
    var pauseable = false
    fileprivate var shouldBePaused = false
    fileprivate var shouldBeHalted = false
    var isUpdating = false
    fileprivate var _halted = false
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

    fileprivate var _paused = false
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

    func randSideAngle(_ sides: [Side]) -> CGFloat {
        return randSideAngle(sides.rand())
    }

    func randSideAngle(_ side: Side? = nil) -> CGFloat {
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

    func outsideWorld(angle: CGFloat) -> CGPoint {
        return outsideWorld(extra: 0, angle: angle)
    }

    func outsideWorld(node: Node, angle: CGFloat) -> CGPoint {
        return outsideWorld(extra: node.radius, angle: angle)
    }

    func outsideWorld(extra dist: CGFloat, angle _angle: CGFloat, ui: Bool = false) -> CGPoint {
        let scale = min(xScale, 1)
        let size = self.size / scale
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

        point += cameraNode.position / scale
        return point
    }

    fileprivate var throttleStragglers = throttle(1)
    fileprivate var didPopulateWorld = false

    var director: WorldView? {
        return (scene as? WorldScene)?.view as? WorldView
    }

    var touchedNodes: [NSObject: (Node, TouchableComponent)] = [:]
    var currentNode: Node? { return selectedNode ?? defaultNode }
    var defaultNode: Node? {
        didSet { currentNodeDidChange(from: selectedNode ?? oldValue) }
    }
    var selectedNode: Node? {
        didSet { currentNodeDidChange(from: oldValue ?? defaultNode) }
    }

    private func currentNodeDidChange(from oldCurrentNode: Node?) {
        if let oldCurrentNode = oldCurrentNode,
            let selectableComponent = oldCurrentNode.selectableComponent,
            oldCurrentNode != currentNode
        {
            selectableComponent.changeSelected(false)
        }

        if let newCurrentNode = currentNode,
            let selectableComponent = newCurrentNode.selectableComponent,
            newCurrentNode != oldCurrentNode
        {
            selectableComponent.changeSelected(true)
        }
    }

    fileprivate var _cachedNodes: [Node]?
    fileprivate var _cachedEnemies: [Node]?
    fileprivate var _cachedPlayers: [Node]?
    var nodes: [Node] { return cachedNodes() }
    var enemies: [Node] { return cachedEnemies() }
    var players: [Node] { return cachedPlayers() }

    typealias OnNoMoreEnemies = Block
    fileprivate var _onNoMoreEnemies = [OnNoMoreEnemies]()
    func onNoMoreEnemies(_ handler: @escaping OnNoMoreEnemies) {
        if enemies.count == 0 {
            handler()
        }
        _onNoMoreEnemies.append(handler)
    }

    func disablePlayers() { setPlayersEnabled(false) }
    func enablePlayers() { setPlayersEnabled(true) }
    fileprivate func setPlayersEnabled(_ enabled: Bool) {
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
        timeline = coder.decode(key: "timeline") ?? timeline
        defaultNode = coder.decode(key: "defaultNode")
    }

    override func encode(with encoder: NSCoder) {
        encoder.encode(timeline, forKey: "timeline")
        encoder.encode(defaultNode, forKey: "defaultNode")
        super.encode(with: encoder)
    }

    override func reset() {
        super.reset()
        _onNoMoreEnemies = []
    }

    fileprivate func _populateWorld() {
        addComponent(cameraZoom)
        cameraNode.addComponent(cameraMove)
    }

    func populateWorld() {
    }

    func restartWorld() {
        director?.presentWorld(type(of: self).init())
    }

}

extension World {

    fileprivate func resetCaches(isEnemy: Bool = true, isPlayer: Bool = true) {
        _cachedNodes = nil
        if isEnemy {
            _cachedEnemies = nil
        }
        if isPlayer {
            _cachedPlayers = nil
        }
    }

    fileprivate func cachedNodes() -> [Node] {
        if let nodes = _cachedNodes {
            return nodes
        }
        let cached = allChildNodes()
        _cachedNodes = cached
        return cached
    }

    fileprivate func cachedEnemies() -> [Node] {
        if let nodes = _cachedEnemies {
            return nodes
        }
        let cached = nodes.filter { node in
            return node.isEnemy
        }
        _cachedEnemies = cached
        return cached
    }

    fileprivate func cachedPlayers() -> [Node] {
        if let nodes = _cachedPlayers {
            return nodes
        }
        let cached = nodes.filter { node in
            return node.isPlayer
        }
        _cachedPlayers = cached
        return cached
    }
}

extension World {

    // also called by addChild
    override func insertChild(_ node: SKNode, at index: Int) {
        super.insertChild(node, at: index)
        if let node = node as? Node {
            processNewNode(node)
        }
    }

    func processNewNode(_ node: Node) {
        let newNodes = [node] + node.allChildNodes()
        for node in newNodes {
            didAdd(node)
        }

        _cachedNodes = nodes + newNodes
        var reacquire = false
        for child in newNodes {
            if child.isEnemy {
                _cachedEnemies = cachedEnemies() + [child]
            }

            if child.isPlayer {
                _cachedPlayers = cachedPlayers() + [child]
                reacquire = true
            }

            if child.fixedPosition != nil {
                updateFixedNode(child)
            }
        }

        if reacquire {
            reacquirePlayerTargets()
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

    override func removeChildren(in nodes: [SKNode]) {
        super.removeChildren(in: nodes)
        resetCaches()
    }

    func didAdd(_ node: Node) {
    }

    func willRemove(_ nodes: [Node]) {
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

    func updateWorld(_ dtReal: CGFloat) {
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

            throttleStragglers(dt, clearStragglers)

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

    fileprivate func clearStragglers() {
        let maxDistance = outerRadius * 2
        for node in allChildNodes() {
            if node.isProjectile && !convertPosition(node).lengthWithin(maxDistance) {
                node.removeFromParent()
            }
        }
    }

}

extension World {

    func selectNode(_ node: Node) {
        selectedNode = node
    }

    func unselectNode(_ node: Node) {
        if selectedNode == node {
            selectedNode = nil
        }
    }

}

extension World {

    func worldShook() {
        print("at time \(timeline.time)")
    }

    func worldTapped(_ id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }
        guard touchedNode.active else { return }

        let location = convert(worldLocation, to: touchedNode)
        touchableComponent.tapped(at: location)
    }

    func worldPressed(_ id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }
        guard touchedNode.active else { return }

        let location = convert(worldLocation, to: touchedNode)
        touchableComponent.pressed(at: location)
    }

    func worldTouchBegan(_ id: NSObject, worldLocation: CGPoint) {
        guard multitouchEnabled || touchedNodes.count == 0 else {
            return
        }

        if let touchedNode = touchableNode(at: worldLocation),
            let touchableComponent = touchedNode.touchableComponentFor(convert(worldLocation, to: touchedNode)),
            touchedNodes.none({ (info) in return info.1.1 == touchableComponent })
        {
            touchedNodes[id] = (touchedNode, touchableComponent)
        }
        else if let currentNode = currentNode,
            let touchableComponent = currentNode.touchableComponentFor(convert(worldLocation, to: currentNode)),
            touchedNodes.none({ (info) in return info.1.1 == touchableComponent })
        {
            touchedNodes[id] = (currentNode, touchableComponent)
        }

        if let (touchedNode, _) = touchedNodes[id],
            !touchedNode.active
        {
            touchedNodes[id] = nil
            return
        }

        if let (touchedNode, touchableComponent) = touchedNodes[id] {
            let location = convert(worldLocation, to: touchedNode)
            if !touchableComponent.shouldAcceptTouch(at: location) {
                if touchedNode == selectedNode {
                    selectedNode = nil
                }
                touchedNodes[id] = nil
            }
            else {
                touchableComponent.touchBegan(at: location)
            }
        }
    }

    func worldTouchEnded(_ id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convert(worldLocation, to: touchedNode)
        touchableComponent.touchEnded(at: location)

        touchedNodes[id] = nil
    }

    func worldDraggingBegan(_ id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convert(worldLocation, to: touchedNode)
        touchableComponent.draggingBegan(at: location)
    }

    func worldDraggingMoved(_ id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convert(worldLocation, to: touchedNode)
        touchableComponent.draggingMoved(at: location)
    }

    func worldDraggingEnded(_ id: NSObject, worldLocation: CGPoint) {
        guard let (touchedNode, touchableComponent) = touchedNodes[id] else { return }

        let location = convert(worldLocation, to: touchedNode)
        touchableComponent.draggingEnded(at: location)
    }

}

extension World {
    func touchableNode(at worldLocation: CGPoint) -> Node? {
        guard interactionEnabled else { return nil }

        let uiNodes: [Node]
        if worldPaused {
            uiNodes = [self.ui]
        }
        else {
            uiNodes = [self.ui, self.gameUI]
        }

        for uiNode in uiNodes {
            if let foundUi = touchableNode(at: worldLocation, inChildren: uiNode.allChildNodes(interactive: true)) {
                return foundUi
            }
        }
        if !worldPaused {
            return touchableNode(at: worldLocation, inChildren: self.allChildNodes(interactive: true))
        }
        return nil
    }

    fileprivate func touchableNode(at worldLocation: CGPoint, inChildren children: [Node]) -> Node? {
        for node in children.reversed() {
            guard node.touchableComponent != nil else { continue }

            let nodeLocation = convert(worldLocation, to: node)
            if let touchableComponent = node.touchableComponentFor(nodeLocation),
                node.active, node.visible, touchableComponent.enabled,
                touchableComponent.containsTouch(at: nodeLocation)
            {
                return node
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
        var fixedNodes: [(Node, Position)] = []
        for uiNode in [ui, gameUI] {
            for sknode in uiNode.children {
                if let node = sknode as? Node,
                    let fixedPosition = node.fixedPosition
                {
                    fixedNodes << (node, fixedPosition)
                }
            }
        }

        for (node, fixedPosition) in fixedNodes {
            node.position = calculateFixedPosition(fixedPosition)
        }
    }

    func updateFixedNode(_ node: Node) {
        guard let fixedPosition = node.fixedPosition else { return }

        node.position = calculateFixedPosition(fixedPosition)
    }

    func calculateFixedPosition(_ position: Position) -> CGPoint {
        return position.positionIn(screenSize: size)
    }

}

extension Level {
    func linkWaves(_ waves: ((NextStepBlock) -> Void)...) {
        guard let beginWave1 = waves.first else { return }

        var nextWave: Block = { self.completeLevel() }
        var nextStep = afterAllWaves(nextWave: nextWave)
        if waves.count > 1 {
            for wave in waves[1..<waves.count].reversed() {
                let prevStep = nextStep
                nextWave = { wave(prevStep) }
                nextStep = afterAllWaves(nextWave: nextWave)
            }
        }
        beginWave1(nextStep)
    }
}
extension World {

    func afterAllWaves(nextWave: @escaping Block) -> NextStepBlock {
        return afterN {
            self.onNoMoreEnemies { nextWave() }
        }
    }
}
