//
//  JiggleComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
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

    override func update(dt: CGFloat) {
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
