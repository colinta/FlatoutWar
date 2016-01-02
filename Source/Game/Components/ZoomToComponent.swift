//
//  ZoomToComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ZoomToComponent: ApplyToNodeComponent {
    var currentScale: CGFloat?
    var target: CGFloat? {
        didSet {
            if _duration != nil && target != nil {
                _rate = nil
            }
        }
    }
    private var _rate: CGFloat? = 0.25
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

    override func defaultApplyTo() {
        super.defaultApplyTo()
        currentScale = node.xScale
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

    typealias OnZoomed = Block
    private var _onZoomed = [OnZoomed]()
    func onZoomed(handler: OnZoomed) {
        if target == nil {
            handler()
        }
        _onZoomed << handler
    }

    override func reset() {
        super.reset()
        _onZoomed = [OnZoomed]()
    }

    override func update(dt: CGFloat) {
        guard let target = target else { return }
        guard let currentScale = currentScale else { return }

        let rate: CGFloat
        if let _rate = _rate {
            rate = _rate
        }
        else if let duration = _duration {
            rate = max(0.1, (target - currentScale) / duration)
            _rate = rate
        }
        else {
            return
        }

        if let newScale = moveValue(currentScale, towards: target, by: rate * dt) {
            self.currentScale = newScale

            if let applyTo = applyTo {
                applyTo.setScale(newScale)
            }
        }
        else {
            self.target = nil

            for handler in _onZoomed {
                handler()
            }
        }
    }

}
