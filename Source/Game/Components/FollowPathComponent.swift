////
///  FollowPathComponent.swift
//

private let oneFrame: CGFloat = 0.01667
class FollowPathComponent: Component {
    private var totalDist: CGFloat = 0
    private(set) var totalTime: CGFloat = 0
    var time: CGFloat = 0
    var velocity: CGFloat = 50
    var pathFn: ((CGFloat, CGFloat) -> CGPoint) {
        didSet {
            time = 0

            let info = pathFn(-1, velocity)
            totalDist = info.x
            totalTime = info.y

            if let node = node {
                let (p, a) = calcPA()
                node.position = p
                node.setRotation(a)
            }
        }
    }

    typealias OnArrived = () -> Void
    private var _onArrived: [OnArrived] = []
    func onArrived(_ handler: @escaping OnArrived) {
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
        pathFn = { _,_  in return .zero }
        super.init()
    }

    override func didAddToNode() {
        let (p, a) = calcPA()
        node.position = p
        node.setRotation(a)
    }

    private func calcPA() -> (CGPoint, CGFloat) {
        let t = min(time, totalTime)
        let currentPoint = pathFn(t, velocity)
        var frameTime = oneFrame * 5
        var angle: CGFloat = 0
        var angleCount: CGFloat = 0
        while frameTime > 0 {
            angle += pathFn(t - frameTime, velocity).angleTo(currentPoint)
            angleCount += 1
            frameTime -= oneFrame
        }
        return (currentPoint, angle / angleCount)
    }

    override func update(_ dt: CGFloat) {
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
            node.setRotation(a)
        }
    }

}
