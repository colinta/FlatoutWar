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
    var control: CGPoint?

    private var start: CGPoint?
    private var time: CGFloat = 0

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
            let a = start.angleTo(target)
            let l = start.distanceTo(target)
            control = (start + target) / 2 + CGPoint(r: l * 0.5, a: a ± TAU_4)
            self.control = control
        }

        let m1 = start + (control - start) * t
        let m2 = control + (target - control) * t
        return m1 + (m2 - m1) * t
    }

    override func update(dt: CGFloat) {
        guard let duration = duration else { return }

        time = time + dt
        let modTime = min(time / duration, 1)
        let modFrame = oneFrame / duration
        guard let position = pointAt(modTime) else { return }
        guard let prevPos = pointAt(modTime - modFrame) else { return }

        let angle = prevPos.angleTo(position)

        apply { applyTo in
            applyTo.position = position
            applyTo.rotateTo(angle)
        }

        if time >= duration {
            for handler in _onArrived {
                handler()
            }
        }
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
