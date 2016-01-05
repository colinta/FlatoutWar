//
//  DraggableComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/23/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DraggableComponent: Component {
    var speed: CGFloat = 30
    var placeholder: SKNode?
    var target: CGPoint?
    private var maxDistance: CGFloat?
    private var centeredAround: Node?
    private(set) var isDragMoving = false
    private var startingLocation: CGPoint?
    private var shouldAdjust = false

    typealias OnDragChange = (Bool) -> Void
    var _onDragChange: [OnDragChange] = []
    var _onDragging: [OnDragChange] = []

    override func reset() {
        super.reset()
        _onDragChange = []
        _onDragging = []
    }

    func onDragChange(handler: OnDragChange) {
        _onDragChange << handler
    }

    func onDragging(handler: OnDragChange) {
        _onDragging << handler
    }

    func maintainDistance(dist: CGFloat, around: Node) {
        self.maxDistance = dist
        self.centeredAround = around
    }

    override func update(dt: CGFloat) {
        if let target = target {
            if let position = node.position.pointTowards(target, speed: speed, dt: dt) {
                node.position = position
                updateDragMoving(true)
            }
            else {
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
        let shouldAdjustThreshold: CGFloat = (node.radius + 5) / WorldScene.worldScale
        shouldAdjust = location.lengthWithin(shouldAdjustThreshold)
        startingLocation = location
        if let placeholder = placeholder {
            placeholder.hidden = false
            placeholder.position = CGPointZero
        }

        for handler in _onDragging {
            handler(true)
        }
    }

    func draggingMoved(prevLocation: CGPoint, location: CGPoint) {
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
                let dist = playerNode.radius + node.radius
                if placeholder.distanceTo(playerNode, within: dist) {
                    let angle = playerNode.angleTo(placeholder)
                    let point = node.convertPoint(CGPoint(r: dist, a: angle), fromNode: node.parent!)
                    placeholder.position = point
                }
            }
        }

        // stay within maxDistance, if applicable
        if let maxDistance = maxDistance, centeredAround = centeredAround {
            if !placeholder.distanceTo(centeredAround, within: maxDistance) {
                let angle = centeredAround.angleTo(placeholder)
                let point = node.convertPoint(CGPoint(r: maxDistance, a: angle), fromNode: node.parent!)
                placeholder.position = point
            }
        }
    }

    func draggingEnded(location: CGPoint) {
        guard let placeholder = placeholder else { return }

        let draggingTarget = placeholder.position
        placeholder.hidden = true

        let minDist: CGFloat = 3
        if !draggingTarget.distanceTo(node.position, within: minDist) {
            self.target = node.position + draggingTarget
        }

        for handler in _onDragging {
            handler(false)
        }
    }

}
