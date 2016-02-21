//
//  ArcToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let oneFrame: CGFloat = 0.016666666666666666

class ArcToComponent: ApplyToNodeComponent {
    var target: CGPoint?
    var arcOffset: CGFloat = 0.25
    var duration: CGFloat?

    private var start: CGPoint?
    private var time: CGFloat = 0
    private var control: CGPoint?

    typealias OnArrived = () -> Void
    private var _onArrived: [OnArrived] = []
    func onArrived(handler: OnArrived) {
        _onArrived << handler
    }

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
            self._onArrived = []
        }
    }

    override func reset() {
        super.reset()
        _onArrived = []
    }

    override func didAddToNode() {
        super.didAddToNode()
        start = node.position
    }

    private func pointAt(t: CGFloat) -> CGPoint? {
        guard let start = start, target = target else { return nil }
        guard t > 0 else { return start }
        guard t < 1 else { return target }

        let control: CGPoint
        if let c = self.control {
            control = c
        }
        else {
            let a = start.angleTo(target) ± TAU_4
            let l = start.distanceTo(target)
            control = 0.5 * (target - start) + CGPoint(r: l * arcOffset, a: a)
            self.control = control
        }

        let m1 = start + (control - start) * t
        let m2 = control + (target - control) * t
        return m1 + (m2 - m1) * t
    }

    override func update(dt: CGFloat) {
        guard let duration = duration else { return }
        let modTime = time / duration
        let modFrame = oneFrame / duration
        guard let position = pointAt(modTime) else { return }

        let angle: CGFloat
        if modTime == 0 {
            guard let nextPos = pointAt(modFrame) else { return }
            angle = position.angleTo(nextPos)
        }
        else {
            guard let prevPos = pointAt(modTime - modFrame) else { return }
            angle = prevPos.angleTo(position)
        }
        time += dt
        guard time < 1 else {
            for handler in _onArrived {
                handler()
            }
            return
        }

        guard let applyTo = applyTo else { return }

        applyTo.position = position
        applyTo.rotateTo(angle)
    }

}

extension Node {
    func arcTo(dest: CGPoint, duration: CGFloat, arcOffset: CGFloat? = nil, start: CGPoint? = nil) -> ArcToComponent {
        let arcTo = ArcToComponent()
        if let start = start {
            self.position = start
        }
        arcTo.target = dest
        if let arcOffset = arcOffset {
            arcTo.arcOffset = arcOffset
        }
        arcTo.duration = duration
        arcTo.removeComponentOnArrived()
        addComponent(arcTo)

        return arcTo
    }
}
