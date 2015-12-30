//
//  FadeToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class FadeToComponent: Component {
    var target: CGFloat? = 1 {
        didSet {
            if _duration != nil {
                _rate = nil
            }
        }
    }
    private var _rate: CGFloat? = CGFloat(1.65)
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

    typealias OnFaded = (Node) -> Void
    private var _onFaded = [OnFaded]()
    func onFaded(handler: OnFaded) {
        _onFaded << handler
    }

    override func reset() {
        _onFaded = [OnFaded]()
    }

    func removeOnFaded() {
        self.onFaded { node in
            node.removeFromParent()
        }
    }

    override func update(dt: CGFloat, node: Node) {
        guard let target = target else { return }

        let rate: CGFloat
        if let _rate = _rate {
            rate = _rate
        }
        else if let duration = _duration {
            rate = CGFloat(abs(target - node.alpha)) / duration
            _rate = rate
        }
        else {
            rate = 0
        }

        var current = node.alpha
        if current < target {
            current += rate * dt
            if current > target {
                current = target
                self.target = nil
            }
        }
        else {
            current -= rate * dt
            if current < target {
                current = target
                self.target = nil
            }
        }

        node.alpha = current

        if self.target == nil {
            for handler in _onFaded {
                handler(node)
            }
            _onFaded = [OnFaded]()
        }
    }

}
