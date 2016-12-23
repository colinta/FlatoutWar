////
///  FadeToComponent.swift
//

class FadeToComponent: ApplyToNodeComponent {
    var target: CGFloat? = 1 {
        didSet {
            if _duration != nil {
                _rate = nil
            }
        }
    }
    private var _rate: CGFloat? = 1.65  // 0.6s
    var rate: CGFloat? {
        get { return _rate }
        set {
            _rate = newValue
        }
    }
    private var _duration: CGFloat?
    var duration: CGFloat? {
        get { return _duration }
        set {
            _duration = newValue
            _rate = nil
        }
    }
    private var currentAlpha: CGFloat { return (applyTo ?? node).alpha }

    convenience init(fadeOut duration: CGFloat) {
        self.init()
        target = 0
        self.duration = duration
        removeNodeOnFade()
    }

    convenience init(fadeIn duration: CGFloat) {
        self.init()
        target = 1
        self.duration = duration
        removeNodeOnFade()
    }

    typealias OnFaded = Block
    private var _onFaded: [OnFaded] = []
    func onFaded(_ handler: @escaping OnFaded) {
        _onFaded << handler
    }

    override func reset() {
        super.reset()
        _onFaded = []
    }

    func removeComponentOnFade() {
        self.onFaded(removeFromNode)
    }

    func removeNodeOnFade() {
        self.onFaded {
            guard let node = self.node else { return }
            node.removeFromParent()
        }
    }

    override func update(_ dt: CGFloat) {
        guard let target = target else { return }

        let rate: CGFloat
        if let _rate = _rate {
            rate = _rate
        }
        else if let duration = _duration {
            rate = CGFloat(abs(target - currentAlpha)) / duration
            _rate = rate
        }
        else {
            rate = 0
        }

        if let newAlpha = moveValue(currentAlpha, towards: target, by: rate * dt) {
            apply { applyTo in
                applyTo.alpha = newAlpha
            }
        }
        else {
            self.target = nil

            for handler in _onFaded {
                handler()
            }
            _onFaded = []
        }
    }

}


extension Node {

    @discardableResult
    func fadeTo(_ alpha: CGFloat, start: CGFloat? = nil, duration: CGFloat? = nil, rate: CGFloat? = nil, removeNode: Bool = false, removeComponent: Bool = true) -> FadeToComponent {
        let fade = fadeToComponent ?? FadeToComponent()
        if let start = start {
            self.alpha = start
        }
        fade.target = alpha
        fade.duration = duration
        fade.rate = rate

        if removeNode {
            fade.removeNodeOnFade()
        }
        else if removeComponent {
            fade.removeComponentOnFade()
        }

        if fadeToComponent == nil {
            addComponent(fade)
        }

        return fade
    }
}
