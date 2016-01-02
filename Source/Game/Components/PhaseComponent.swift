//
//  PhaseComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/1/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PhaseComponent: Component {
    var loops = true
    var easing = Easing.Linear
    private var _phase: CGFloat = 0
    var phase: CGFloat {
        get { return easing.ease(time: _phase, initial: 0, final: 1) }
        set { _phase = newValue }
    }
    var duration: CGFloat = 0

    var value: CGFloat { return min + (max - min) * phase }
    var min: CGFloat = 0
    var max: CGFloat = 0

    override func update(dt: CGFloat) {
        guard duration > 0 else { return }
        _phase = (_phase + dt / duration)
        if loops {
            _phase = _phase % 1.0
        }
        else if _phase > 1 {
            _phase = 1
        }
    }

}
