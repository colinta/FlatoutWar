////
///  ScaleToComponent.swift
//

class ScaleToComponent: ApplyToNodeComponent {
    var currentScale: CGFloat?
    var target: CGFloat? = 1 {
        didSet {
            currentScale = node?.xScale

            if _duration != nil && target != nil {
                _rate = nil
            }
        }
    }
    private var _rate: CGFloat? = 1.65
    var rate: CGFloat? {
        get { return _rate }
        set {
            _rate = newValue
            if newValue != nil {
                _duration = nil
            }
        }
    }
    private var _duration: CGFloat?
    var duration: CGFloat? {
        get { return _duration }
        set {
            _duration = newValue
            if newValue != nil {
                _rate = nil
            }
        }
    }
    private var time: CGFloat?
    private var initialScale: CGFloat?
    var easing: Easing? {
        didSet {
            time = 0
            initialScale = node?.xScale
        }
    }

    convenience init(scaleOut duration: CGFloat) {
        self.init()
        target = 0
        self.duration = duration
        removeNodeOnScale()
    }

    convenience init(scaleIn duration: CGFloat) {
        self.init()
        target = 1
        self.duration = duration
        removeNodeOnScale()
    }

    typealias OnScaled = Block
    private var _onScaled: [OnScaled] = []
    func onScaled(_ handler: @escaping OnScaled) {
        _onScaled << handler
    }

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentScale = node.xScale
        initialScale = node.xScale
    }

    override func reset() {
        super.reset()
        _onScaled = []
    }

    func removeComponentOnScale() {
        self.onScaled(removeFromNode)
    }

    func removeNodeOnScale() {
        self.onScaled {
            guard let node = self.node else { return }
            node.removeFromParent()
        }
    }

    override func update(_ dt: CGFloat) {
        guard let target = target, let currentScale = currentScale else { return }

        let rate: CGFloat
        if let _rate = _rate {
            rate = _rate
        }
        else if let duration = _duration,
            duration > 0
        {
            rate = (target - currentScale) / duration
            _rate = rate
        }
        else {
            return
        }

        var newScale: CGFloat? = nil
        if let easing = easing, let time = time, let duration = _duration {
            let newTime = time + dt / duration
            self.time = newTime
            if newTime < 1 {
                newScale = easing.ease(time: newTime, initial: initialScale!, final: target)
            }
        }
        else if let linearScale = moveValue(currentScale, towards: target, by: rate * dt) {
            newScale = linearScale
        }

        if let newScale = newScale {
            self.currentScale = newScale
            apply { applyTo in
                applyTo.setScale(newScale)
            }
        }
        else {
            self.target = nil
            self.currentScale = target
            apply { applyTo in
                applyTo.setScale(target)
            }
            for handler in _onScaled {
                handler()
            }
        }
    }

}


extension Node {

    @discardableResult
    func scaleTo(_ targetScale: CGFloat, start: CGFloat? = nil, duration: CGFloat? = nil, rate: CGFloat? = nil, removeNode: Bool = false, removeComponent: Bool = true, easing: Easing? = nil) -> ScaleToComponent {
        let scaleTo = get(component: ScaleToComponent.self) ?? ScaleToComponent()
        if let start = start {
            self.setScale(start)
            scaleTo.currentScale = start
        }
        else {
            scaleTo.currentScale = self.xScale
        }
        scaleTo.target = targetScale
        scaleTo.duration = duration
        scaleTo.rate = rate
        scaleTo.easing = easing

        if removeNode {
            scaleTo.removeNodeOnScale()
        }
        else if removeComponent {
            scaleTo.removeComponentOnScale()
        }

        addComponent(scaleTo)

        return scaleTo
    }
}
