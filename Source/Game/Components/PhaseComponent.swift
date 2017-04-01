////
///  PhaseComponent.swift
//

class PhaseComponent: Component {
    var loops = false
    var easing = Easing.Linear
    private var _phase: CGFloat = 0
    var phase: CGFloat {
        get { return easing.ease(time: _phase, initial: 0, final: 1) }
        set { _phase = newValue }
    }
    var duration: CGFloat = 0

    typealias OnPhase = (CGFloat) -> Void
    private var _onPhase: [OnPhase] = []
    func onPhase(_ handler: @escaping OnPhase) {
        _onPhase << handler
    }

    typealias OnValue = (CGFloat) -> Void
    private var _onValue: [OnValue] = []
    func onValue(_ handler: @escaping OnValue) {
        _onValue << handler
    }

    var value: CGFloat { return startValue + (finalValue - startValue) * phase }
    var startValue: CGFloat = 0
    var finalValue: CGFloat = 1

    override func reset() {
        super.reset()
        _onPhase = []
        _onValue = []
    }

    override func update(_ dt: CGFloat) {
        guard duration > 0 else { return }

        _phase = (_phase + dt / duration)
        if loops {
            _phase = _phase.truncatingRemainder(dividingBy: 1)
        }
        else if _phase > 1 {
            _phase = 1
        }

        if _onPhase.count > 0 {
            let phase = self.phase
            for handler in _onPhase {
                handler(phase)
            }
        }

        if _onValue.count > 0 {
            let value = self.value
            for handler in _onValue {
                handler(value)
            }
        }
    }

}
