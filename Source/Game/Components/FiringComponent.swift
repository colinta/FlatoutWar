//
//  FiringComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class FiringComponent: Component {
    var cooldown: CGFloat = 1
    private(set) var angle: CGFloat?
    var lastFired: CGFloat = 0
    var cantFire: CGFloat = 0
    var forceFire = false {
        willSet {
            if newValue != forceFire {
                if !newValue {
                    if cantFire <= 0 {
                        cantFire = cooldown * 2
                    }
                }
                else {
                    if cantFire <= cooldown {
                        lastFired = cooldown
                        cantFire = 0
                    }
                }
            }
        }
    }

    typealias OnFire = (angle: CGFloat) -> Void
    var _onFire: [OnFire] = []
    func onFire(handler: OnFire) { _onFire << handler }

    override func reset() {
        super.reset()
        _onFire = []
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

    override func update(dt: CGFloat) {
        guard lastFired <= 0 else {
            lastFired -= dt
            return
        }
        guard cantFire <= 0 else {
            cantFire -= dt
            return
        }

        angle = nil
        if forceFire {
            self.angle = node.zRotation
            for handler in _onFire {
                handler(angle: node.zRotation)
            }
            lastFired = cooldown
        }
        else if let targetingComponent = node.targetingComponent,
            let angle = targetingComponent.angleToCurrentTarget()
            where targetingComponent.enabled
        {
            self.angle = angle
            for handler in _onFire {
                handler(angle: angle)
            }
            lastFired = cooldown
        }
    }
}
