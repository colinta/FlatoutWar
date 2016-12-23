////
///  Easing.swift
//

typealias EasingEquation = (CGFloat, CGFloat, CGFloat) -> CGFloat

func easeLinear(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    guard time > 0 else { return initial }
    guard time < 1 else { return finalValue }
    return initial + (finalValue - initial) * time
}

func easeOutExpo(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    guard time > 0 else { return initial }
    guard time < 1 else { return finalValue }
    let delta = finalValue - initial
    let dist: CGFloat = 1 - pow(2, -10 * time)
    return delta * dist + initial
}

func easeOutCubic(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    guard time > 0 else { return initial }
    guard time < 1 else { return finalValue }
    let delta = finalValue - initial
    let dist = pow(time - 1, 3) + 1
    return delta * dist + initial
}

func easeOutElastic(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    guard time > 0 else { return initial }
    guard time < 1 else { return finalValue }

    let p: CGFloat = 0.3
    let s = p / 4

    return (finalValue - initial) * pow(2, -10 * time) * sin((time - s) * TAU / p) + finalValue
}

func easeInElastic(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    guard time > 0 else { return initial }
    guard time < 1 else { return finalValue }
    return easeOutElastic(time: 1 - time, initial: finalValue, final: initial)
}

func easeInBack(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    let s: CGFloat = 1.70158
    return (finalValue - initial) * time * time * ((s + 1) * time - s) + initial
}

func easeReverseQuad(time: CGFloat, initial: CGFloat = 0, final finalValue: CGFloat = 1) -> CGFloat {
    let a = 4 * (initial - finalValue)
    let b = 4 * (finalValue - initial)
    return a * pow(time, 2) + b * time + initial
}

enum Easing {
    case Linear
    case EaseInBack
    case EaseInElastic
    case EaseOutCubic
    case EaseOutElastic
    case EaseOutExpo
    case ReverseQuad
    case Custom(EasingEquation)

    func ease(time: CGFloat, initial: CGFloat, final: CGFloat) -> CGFloat {
        switch self {
        case .Linear: return easeLinear(time: time, initial: initial, final: final)
        case .EaseInElastic: return easeInElastic(time: time, initial: initial, final: final)
        case .EaseInBack: return easeInBack(time: time, initial: initial, final: final)
        case .EaseOutCubic: return easeOutCubic(time: time, initial: initial, final: final)
        case .EaseOutElastic: return easeOutElastic(time: time, initial: initial, final: final)
        case .EaseOutExpo: return easeOutExpo(time: time, initial: initial, final: final)
        case .ReverseQuad: return easeReverseQuad(time: time, initial: initial, final: final)
        case let .Custom(eq): return eq(time, initial, final)
        }
    }

}
