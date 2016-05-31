//
//  ArcToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let oneFrame: CGFloat = 0.016666666666666666
private let accuracy: CGFloat = 0.05

class ArcToComponent: ApplyToNodeComponent {
    var target: CGPoint?
    var arcOffset: CGFloat = 0.5
    var speed: CGFloat?
    private var current: CGPoint?
    var control: CGPoint?
    var control2: CGPoint?
    var rotate = true

    private var start: CGPoint?
    private var time: CGFloat = 0
    private var prevDelta: CGFloat?

    typealias OnArrived = () -> Void
    private var _onArrived: [OnArrived] = []
    func onArrived(handler: OnArrived) {
        _onArrived << handler
    }
    func clearOnArrived() { _onArrived = [] }

    typealias OnMoved = (CGFloat) -> Void
    private var _onMoved: [OnMoved] = []
    func onMoved(handler: OnMoved) {
        _onMoved << handler
    }
    func clearOnMoved() { _onMoved = [] }

    func removeComponentOnArrived() {
        self.onArrived(removeFromNode)
    }

    func removeNodeOnArrived() {
        self.onArrived {
            guard let node = self.node else { return }
            node.removeFromParent()
        }
    }

    func resetOnArrived() {
        self.onArrived {
            self.clearOnArrived()
            self.clearOnMoved()
        }
    }

    override func reset() {
        super.reset()
        clearOnArrived()
        clearOnMoved()
    }

    override func didAddToNode() {
        super.didAddToNode()
        if start == nil {
            start = node.position
        }
    }

    private func pointAt(t: CGFloat, start: CGPoint, target: CGPoint) -> CGPoint {
        guard t > 0 else { return start }
        guard t < 1 else { return target }

        let control: CGPoint
        if let c = self.control {
            control = c
        }
        else {
            let a = start.angleTo(target)
            let l = start.distanceTo(target)
            control = (start + target) / 2 + CGPoint(r: l * arcOffset, a: a ± TAU_4)
            self.control = control
        }

        if let control2 = control2 {
            let m1 = start + (control - start) * t
            let m2 = control + (control2 - control) * t
            let m3 = control2 + (target - control2) * t

            let m4 = m1 + (m2 - m1) * t
            let m5 = m2 + (m3 - m2) * t
            return m4 + (m5 - m4) * t
        }
        else {
            let m1 = start + (control - start) * t
            let m2 = control + (target - control) * t
            return m1 + (m2 - m1) * t
        }
    }

    private func calcNextTime(time: CGFloat, current: CGPoint, start: CGPoint, target: CGPoint, maxLength: CGFloat) -> (CGFloat, CGPoint) {
        guard !current.distanceTo(target, within: maxLength) else {
            return (1, target)
        }

        var guessDelta: CGFloat
        if let prevDelta = prevDelta {
            guessDelta = prevDelta
        }
        else {
            guessDelta = 0.1
        }

        var nextTime: CGFloat!
        var nextPoint: CGPoint!
        var iter = 5
        while true {
            nextTime = time + guessDelta
            nextPoint = pointAt(nextTime, start: start, target: target)
            let length = current.distanceTo(nextPoint)
            if abs(maxLength - length) < accuracy {
                break
            }
            iter -= 1
            if iter == 0 {
                return calcNextTimeAlt(time, current: current, start: start, target: target, maxLength: maxLength)
            }

            if length > 0.0001 {
                guessDelta = guessDelta * maxLength / length
            }
            else {
                guessDelta = 0.1
            }
        }
        prevDelta = guessDelta
        return (nextTime, nextPoint)
    }

    private func calcNextTimeAlt(time: CGFloat, current: CGPoint, start: CGPoint, target: CGPoint, maxLength: CGFloat) -> (CGFloat, CGPoint) {
        let dt: CGFloat = 0.01
        var nextTime = time, prevTime: CGFloat?
        var nextPoint: CGPoint!, prevPoint: CGPoint?
        while true {
            nextTime += dt
            nextPoint = pointAt(nextTime, start: start, target: target)
            let length = current.distanceTo(nextPoint)
            if length > maxLength {
                break
            }
            prevTime = nextTime
            prevPoint = nextPoint
        }
        return (prevTime ?? nextTime, prevPoint ?? nextPoint)
    }

    override func update(dt: CGFloat) {
        guard let speed = speed, current = self.current ?? self.start, start = start, target = target else { return }

        let length = speed * dt
        let (calcTime, calcPoint) = calcNextTime(time, current: current, start: start, target: target, maxLength: length)

        let nextTime: CGFloat
        let nextPoint: CGPoint
        if calcPoint.distanceTo(target, within: 0.5) {
            nextTime = 1
            nextPoint = target
        }
        else {
            nextTime = calcTime
            nextPoint = calcPoint
        }

        for handler in _onMoved {
            handler(nextTime)
        }

        apply { applyTo in
            applyTo.position = nextPoint
            if self.rotate {
                let angle = current.angleTo(nextPoint)
                applyTo.rotateTo(angle)
            }
        }
        self.current = nextPoint
        self.time = nextTime

        if nextTime == 1 {
            for handler in _onArrived {
                handler()
            }
        }
    }

}

extension Node {
    func arcTo(dest: CGPoint, control: CGPoint? = nil, start: CGPoint? = nil, speed: CGFloat, arcOffset: CGFloat? = nil, removeNode: Bool = false, removeComponent: Bool = true) -> ArcToComponent {
        let arcTo = ArcToComponent()
        if let start = start {
            self.position = start
            arcTo.start = start
        }
        else {
            arcTo.start = self.position
        }
        arcTo.target = dest
        arcTo.control = control
        if let arcOffset = arcOffset {
            arcTo.arcOffset = arcOffset
        }
        arcTo.speed = speed
        if removeNode {
            arcTo.removeNodeOnArrived()
        }
        else if removeComponent {
            arcTo.removeComponentOnArrived()
        }
        addComponent(arcTo)

        return arcTo
    }
}
