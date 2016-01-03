//
//  FadeToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class FadeToComponent: ApplyToNodeComponent {
    var currentAlpha: CGFloat?
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
            _duration = nil
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

    typealias OnFaded = Block
    private var _onFaded: [OnFaded] = []
    func onFaded(handler: OnFaded) {
        _onFaded << handler
    }

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentAlpha = node.alpha
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

    override func update(dt: CGFloat) {
        guard let target = target else { return }
        guard let currentAlpha = currentAlpha else { return }

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

        let newAlpha: CGFloat
        if currentAlpha < target {
            newAlpha = min(currentAlpha + rate * dt, target)
            if newAlpha == target {
                self.target = nil
            }
        }
        else {
            newAlpha = max(currentAlpha - rate * dt, target)
            if newAlpha == target {
                self.target = nil
            }
        }

        self.currentAlpha = newAlpha

        if self.target == nil {
            for handler in _onFaded {
                handler()
            }
            _onFaded = []
        }

        guard let applyTo = applyTo else { return }
        applyTo.alpha = newAlpha
    }

}
