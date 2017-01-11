////
///  JiggleComponent.swift
//

private let InitialTimeout: CGFloat = 3

class JiggleComponent: ApplyToNodeComponent {
    var start: CGPoint?
    var timeout: CGFloat? = InitialTimeout
    var initialTimeout: CGFloat? = InitialTimeout {
        didSet { timeout = initialTimeout }
    }

    convenience init(timeout: CGFloat?) {
        self.init()
        self.timeout = timeout
        self.initialTimeout = timeout
    }

    required override init() {
        super.init()
    }

    override func reset() {
        super.reset()
    }

    func resetTimeout() {
        self.timeout = initialTimeout
    }

    override func didAddToNode() {
        super.didAddToNode()
        start = node.position
    }

    override func update(_ dt: CGFloat) {
        if let start = start {
            if var timeout = timeout {
                timeout = timeout - dt
                guard timeout > 0 else {
                    apply { applyTo in
                        applyTo.position = start
                    }
                    removeFromNode()
                    return
                }
                self.timeout = timeout
            }

            apply { applyTo in
                applyTo.position = start + CGPoint(r: rand(min: 0, max: 1), a: rand(TAU))
            }
        }
    }

}
