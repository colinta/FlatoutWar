//
//  ScaleToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ScaleToComponent: ApplyToNodeComponent {
    var currentScale: CGFloat?
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
    func onScaled(handler: OnScaled) {
        _onScaled << handler
    }

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentScale = node.xScale
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

    override func update(dt: CGFloat) {
        guard let target = target else { return }
        guard let currentScale = currentScale else { return }

        let rate: CGFloat
        if let _rate = _rate {
            rate = _rate
        }
        else if let duration = _duration {
            rate = CGFloat(abs(target - currentScale)) / duration
            _rate = rate
        }
        else {
            rate = 0
        }

        let newScale: CGFloat
        if currentScale < target {
            newScale = min(currentScale + rate * dt, target)
            if newScale == target {
                self.target = nil
            }
        }
        else {
            newScale = max(currentScale - rate * dt, target)
            if newScale == target {
                self.target = nil
            }
        }

        self.currentScale = newScale

        if self.target == nil {
            for handler in _onScaled {
                handler()
            }
            _onScaled = []
        }

        guard let applyTo = applyTo else { return }
        applyTo.setScale(newScale)
    }

}


extension Node {

    func scaleTo(targetScale: CGFloat, start: CGFloat? = nil, duration: CGFloat? = nil, rate: CGFloat? = nil, removeNode: Bool = false) -> ScaleToComponent {
        let scale = scaleToComponent ?? ScaleToComponent()
        if let start = start {
            self.setScale(start)
            scale.currentScale = start
        }
        else {
            scale.currentScale = self.xScale
        }
        scale.target = targetScale
        scale.duration = duration
        scale.rate = rate

        if removeNode {
            scale.removeNodeOnScale()
        }
        else {
            scale.removeComponentOnScale()
        }

        if scaleToComponent == nil {
            addComponent(scale)
        }

        return scale
    }
}
