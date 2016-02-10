//
//  FollowPathComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let oneFrame: CGFloat = 0.01667
class FollowPathComponent: Component {
    private var totalDist: CGFloat = 0
    private(set) var totalTime: CGFloat = 0
    var time: CGFloat = 0
    var velocity: CGFloat = 50
    var pathFn: (t: CGFloat, v: CGFloat) -> (CGPoint) {
        didSet {
            time = 0

            let info = pathFn(t: -1, v: velocity)
            totalDist = info.x
            totalTime = info.y

            if let node = node {
                let (p, a) = calcPA()
                node.position = p
                node.rotateTo(a)
            }
        }
    }

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

    required override init() {
        pathFn = { _ in return .zero }
        super.init()
    }

    required init?(coder: NSCoder) {
        pathFn = { _ in return .zero }
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func didAddToNode() {
        let (p, a) = calcPA()
        node.position = p
        node.rotateTo(a)
    }

    private func calcPA() -> (CGPoint, CGFloat) {
        let t = min(time, totalTime)
        let prevPoint = pathFn(t: t - oneFrame, v: velocity)
        let currentPoint = pathFn(t: t, v: velocity)
        return (currentPoint, prevPoint.angleTo(currentPoint))
    }

    override func update(dt: CGFloat) {
        time += dt
        let (p, a) = calcPA()

        if time >= totalTime {
            let keepMoving = KeepMovingComponent(velocity: CGPoint(r: velocity, a: a))
            node.addComponent(keepMoving)

            for handler in _onArrived {
                handler()
            }

            removeFromNode()
        }
        else {
            node.position = p
            node.rotateTo(a)
        }
    }

}
