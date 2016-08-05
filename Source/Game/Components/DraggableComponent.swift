////
///  DraggableComponent.swift
//

protocol DraggableNode: class {
    var placeholder: SKSpriteNode { get }
}

class DraggableComponent: Component {
    var speed: CGFloat? = 30
    var placeholder: SKNode? { return (node as? DraggableNode)?.placeholder }
    var target: CGPoint?
    var shouldAdjustEnabled: Bool?

    override var enabled: Bool {
        didSet {
            if !enabled {
                draggingCanceled()
                if isDragMoving {
                    updateDragMoving(false)
                }
            }
        }
    }
    private var maxDistance: CGFloat?
    private var centeredAround: Node?
    private(set) var isDragMoving = false
    private(set) var isIgnoring = false
    private var isDragging = false
    private var startingLocation: CGPoint?
    private var shouldAdjust = false

    typealias OnDragChange = (Bool) -> Void
    typealias OnDragging = (Bool, CGPoint) -> Void
    var _onDragChange: [OnDragChange] = []
    var _onDragging: [OnDragging] = []

    override func reset() {
        super.reset()
        _onDragChange = []
        _onDragging = []
    }

    override func didAddToNode() {
        super.didAddToNode()

        if let around = centeredAround, dist = maxDistance
            where !node.distanceTo(around, within: dist)
        {
            let angle = around.angleTo(node)
            node.position = around.position + CGPoint(r: dist, a: angle)
        }

    }

    func onDragChange(handler: OnDragChange) {
        _onDragChange << handler
    }

    func onDragging(handler: OnDragging) {
        _onDragging << handler
    }

    func dontMaintainDistance() {
        self.maxDistance = nil
        self.centeredAround = nil
    }

    func maintainDistance(maxDist: CGFloat, around aroundNode: Node) {
        if let node = node
        where
            !node.distanceTo(aroundNode, within: maxDist) ||
            node.distanceTo(aroundNode) < aroundNode.radius
        {
            let angle = aroundNode.angleTo(node)
            node.position = aroundNode.position + CGPoint(r: maxDist, a: angle)
        }

        self.maxDistance = maxDist
        self.centeredAround = aroundNode
    }

    override func update(dt: CGFloat) {
        if let target = target {
            if let speed = speed,
                position = node.position.pointTowards(target, speed: speed, dt: dt)
            {
                node.position = position
                updateDragMoving(true)
            }
            else {
                node.position = target
                self.target = nil
                updateDragMoving(false)
            }
        }
    }

    private func updateDragMoving(isMoving: Bool) {
        if isDragMoving != isMoving {
            isDragMoving = isMoving
            for handler in _onDragChange {
                handler(isMoving)
            }
        }
    }

    func bindTo(touchableComponent touchableComponent: TouchableComponent) {
        touchableComponent.on(.DragBegan, draggingBegan)
        touchableComponent.on(.DragEnded, draggingEnded)
        touchableComponent.onDragged(draggingMoved)
    }

    func draggingBegan(location: CGPoint) {
        guard enabled && !isDragMoving else {
            isIgnoring = true
            return
        }
        isIgnoring = false
        isDragging = true

        if let shouldAdjustEnabled = shouldAdjustEnabled {
            shouldAdjust = shouldAdjustEnabled
        }
        else {
            let shouldAdjustThreshold: CGFloat = (node.radius + 5) / WorldScene.worldScale
            shouldAdjust = location.lengthWithin(shouldAdjustThreshold)
        }

        startingLocation = location
        if let placeholder = placeholder {
            placeholder.hidden = false
            placeholder.position = .zero
        }

        for handler in _onDragging {
            handler(true, location)
        }
    }

    func draggingMoved(prevLocation: CGPoint, location: CGPoint) {
        guard !isIgnoring else { return }

        guard let placeholder = placeholder, startingLocation = startingLocation else {
            return
        }
        var draggingDelta = location - startingLocation

        if shouldAdjust {
            let distance = location.distanceTo(startingLocation)

            let fingerDistance: CGFloat = 70 / WorldScene.worldScale
            let fingerThreshold = fingerDistance * 2

            var distanceDelta: CGFloat = 0
            if distance >= fingerThreshold {
                distanceDelta = fingerDistance
            }
            else {
                distanceDelta = distance / fingerThreshold * fingerDistance
            }

            let angle = startingLocation.angleTo(location)
            let distanceX = distance - distanceDelta
            let distanceY: CGFloat
            if draggingDelta.y < 0 {
                distanceY = distance - distanceDelta
            }
            else {
                distanceY = distance + distanceDelta
            }

            draggingDelta.x = distanceX * cos(angle)
            draggingDelta.y = distanceY * sin(angle)
        }

        placeholder.position = draggingDelta

        // avoid all "player" nodes
        if let players = node.world?.players {
            for playerNode in players {
                if playerNode == node { continue }

                let minDist = playerNode.radius + node.radius
                if placeholder.distanceTo(playerNode, within: minDist) {
                    let angle = playerNode.angleTo(placeholder)
                    let point = node.convertPoint(playerNode.position + CGPoint(r: minDist, a: angle), fromNode: node.parent!)
                    placeholder.position = point
                }
            }
        }

        // stay within maxDistance, if applicable
        if let maxDistance = maxDistance, centeredAround = centeredAround {
            if !placeholder.distanceTo(centeredAround, within: maxDistance) {
                let angle = centeredAround.angleTo(placeholder)
                let point = node.convertPoint(centeredAround.position + CGPoint(r: maxDistance, a: angle), fromNode: node.parent!)
                placeholder.position = point
            }
        }

        for handler in _onDragging {
            handler(true, location)
        }
    }

    func draggingCanceled() {
        guard isDragging else { return }

        isIgnoring = true
        placeholder?.hidden = true
        self.target = nil
        isDragging = false
        for handler in _onDragging {
            handler(false, placeholder?.position ?? .zero)
        }
    }

    func draggingEnded(location: CGPoint) {
        guard !isIgnoring else {
            isIgnoring = false
            return
        }

        guard let placeholder = placeholder else { return }

        placeholder.hidden = true

        let draggingTarget = placeholder.position
        let minDist: CGFloat = 3
        if !draggingTarget.distanceTo(node.position, within: minDist) {
            self.target = node.position + draggingTarget
        }

        isDragging = false
        for handler in _onDragging {
            handler(false, location)
        }
    }

}
