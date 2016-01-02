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
    private var startingLocation: CGPoint?
    private var shouldAdjust = false
    private var isDragMoving = false

    typealias OnDragMove = (Node, Bool) -> Void
    typealias SimpleOnDragMove = (Bool) -> Void
    var _onDragMove: [OnDragMove] = []

    override func reset() {
        super.reset()
        _onDragMove = []
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
            for handler in _onDragMove {
                handler(node, isMoving)
            }
        }
    }

    func onDragMoveNode(handler: OnDragMove) {
        _onDragMove << handler
    }

    func onDragMove(handler: SimpleOnDragMove) {
        _onDragMove << { _, selected in handler(selected) }
    }

    func bindTo(touchableComponent touchableComponent: TouchableComponent) {
        touchableComponent.on(.DragBegan, draggingBegan)
        touchableComponent.on(.DragEnded, draggingEnded)
        touchableComponent.onDragged(draggingMoved)
    }

    func draggingBegan(location: CGPoint) {
        let shouldAdjustThreshold: CGFloat = 10
        shouldAdjust = location.lengthWithin(shouldAdjustThreshold)
        startingLocation = location
        if let placeholder = placeholder {
            placeholder.hidden = false
            placeholder.position = node.position
        }
    }

    func draggingMoved(prevLocation: CGPoint, location: CGPoint) {
        guard let placeholder = placeholder, startingLocation = startingLocation else {
            return
        }
        var draggingDelta = location - startingLocation

        if shouldAdjust {
            let distance = location.distanceTo(startingLocation)

            let fingerDistance: CGFloat = 60
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
    }

    func draggingEnded(location: CGPoint) {
        guard let placeholder = placeholder else { return }

        let draggingTarget = placeholder.position
        placeholder.hidden = true

        let minDist: CGFloat = 3
        if !draggingTarget.distanceTo(node.position, within: minDist) {
            self.target = node.position + draggingTarget
        }
    }

}
