////
///  Rand.swift
//

func rand() -> Bool {
    return arc4random_uniform(2) == 1
}

func rand(_ limit: Int) -> CGFloat {
    return CGFloat(drand48() * Double(limit))
}

func rand(_ limit: CGFloat) -> CGFloat {
    return CGFloat(drand48()) * limit
}

func rand(weighted limit: CGFloat) -> CGFloat {
    let weight = CGFloat(drand48())
    return weight*weight*weight * limit
}

func rand(weighted limit: Float) -> Float {
    let weight = Float(drand48())
    return weight*weight*weight * limit
}

func rand(_ limit: Int) -> Int {
    return Int(arc4random_uniform(UInt32(limit)))
}

func rand(_ limit: Float) -> Int {
    return Int(drand48() * Double(limit))
}

func rand(_ limit: Double) -> Int {
    return Int(drand48() * limit)
}

func rand(_ limit: CGFloat) -> Int {
    return Int(drand48() * Double(limit))
}

func rand(_ range: CountableClosedRange<Int>) -> CGFloat {
    let min = range.lowerBound
    let max = range.upperBound - 1
    return rand(min: min, max: max)
}

func rand(min: Int, max: Int) -> CGFloat {
    return CGFloat(Double(min) + drand48() * Double(max - min))
}

func rand(min: Float, max: Float) -> CGFloat {
    return CGFloat(Double(min) + drand48() * Double(max - min))
}

func rand(min: Double, max: Double) -> CGFloat {
    return CGFloat(Double(min) + drand48() * (max - min))
}

func rand(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Double(min) + drand48() * Double(max - min))
}

func rand(_ range: CountableClosedRange<Int>) -> Int {
    let min = range.lowerBound
    let max = range.upperBound - 1
    return min + Int(arc4random_uniform(UInt32(max - min)))
}

func rand<T>(weights weightValues: (T, Float)...) -> T {
    let weights = weightValues.map { $0.1 }
    let totalWeight: Float = weights.reduce(0, +)
    var rnd: Float = Float(drand48() * Double(totalWeight))
    for (i, el) in weightValues.enumerated() {
        rnd -= weights[i]
        if rnd < 0 {
            return el.0
        }
    }
    return weightValues.last!.0
}

infix operator ± : AdditionPrecedence

prefix operator ±

prefix func ±(lhs: CGFloat) -> CGFloat {
    if rand() {
        return lhs
    }
    else {
        return -lhs
    }
}

func ±(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    if rand() {
        return lhs + rhs
    }
    else {
        return lhs - rhs
    }
}
