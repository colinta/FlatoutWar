//
////
///  Math.swift
//

let M_EPSILON: CGFloat = 0.00872664153575897

let TAU = CGFloat(2 * M_PI)
let τ = TAU
let TAU_2 = CGFloat(M_PI)
let TAU_3 = CGFloat(2 * M_PI / 3)
let TAU_2_3 = CGFloat(4 * M_PI / 3)

let TAU_6 = CGFloat(M_PI / 3)
let TAU_12 = CGFloat(M_PI / 6)
let TAU_5_6 = CGFloat(5 * M_PI / 3)

let TAU_3_4 = CGFloat(1.5 * M_PI)
let TAU_4 = CGFloat(0.5 * M_PI)

let TAU_8 = CGFloat(0.25 * M_PI)
let TAU_3_8 = CGFloat(0.75 * M_PI)
let TAU_5_8 = CGFloat(1.25 * M_PI)
let TAU_7_8 = CGFloat(1.75 * M_PI)

let TAU_16 = CGFloat(0.125 * M_PI)

func normalizeAngle(_ input: CGFloat) -> CGFloat {
    return (TAU + input.truncatingRemainder(dividingBy: TAU)).truncatingRemainder(dividingBy: TAU)
}

func deltaAngle(_ current: CGFloat, target: CGFloat) -> CGFloat {
    let ccw = normalizeAngle(target - current)
    let cw = normalizeAngle(current - target)
    if abs(ccw) < M_EPSILON || abs(cw) < M_EPSILON {
        return 0
    }

    if abs(ccw) < abs(cw) {
        return abs(ccw)
    }
    else {
        return -abs(cw)
    }
}

func moveValue(_ current: CGFloat, towards dest: CGFloat, by amt: CGFloat) -> CGFloat? {
    if current < dest {
        return min(current + abs(amt), dest)
    }
    else if current > dest {
        return max(current - abs(amt), dest)
    }
    else {
        return nil
    }
}

func moveValue(_ current: CGFloat, towards dest: CGFloat, up: @autoclosure () -> CGFloat, down: @autoclosure () -> CGFloat) -> CGFloat? {
    if current < dest {
        return min(current + up(), dest)
    }
    else if current > dest {
        return max(current - down(), dest)
    }
    else {
        return nil
    }
}

func moveAngle(_ current: CGFloat, towards target: CGFloat, by amt: CGFloat) -> CGFloat? {
    let delta = deltaAngle(current, target: target)
    if abs(delta) < M_EPSILON || abs(delta) < amt {
        return nil
    }

    if delta < 0 {
        return normalizeAngle(current - abs(amt))
    }
    else {
        return normalizeAngle(current + abs(amt))
    }
}

func interpolate(_ x: CGFloat, from f: (CGFloat, CGFloat), to: (CGFloat, CGFloat)) -> CGFloat {
    let a1 = f.0,
        a2 = f.1,
        b1 = to.0,
        b2 = to.1
    guard a1 != a2 else { return b1 }

    return (b2 - b1) / (a2 - a1) * (x - a1) + b1
}

func areaOf(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
    let sum = a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)
    return CGFloat(abs(sum) / 2.0)
}

func areaOf(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint, _ d: CGPoint) -> CGFloat {
    return areaOf(a, b, c) + areaOf(c, d, a)
}

func hex(r: Int, g: Int, b: Int) -> Int {
    return r << 16 + g << 8 + b
}

func interpolateHex(_ x: CGFloat, from f: (CGFloat, CGFloat), to: (Int, Int)) -> Int {
    let r0 = (to.0 & 0xFF0000) >> 16
    let r1 = (to.1 & 0xFF0000) >> 16
    let g0 = (to.0 & 0x00FF00) >> 8
    let g1 = (to.1 & 0x00FF00) >> 8
    let b0 = (to.0 & 0x0000FF)
    let b1 = (to.1 & 0x0000FF)
    let r: Int = Int(round(interpolate(x, from: f, to: (CGFloat(r0), CGFloat(r1)))))
    let g: Int = Int(round(interpolate(x, from: f, to: (CGFloat(g0), CGFloat(g1)))))
    let b: Int = Int(round(interpolate(x, from: f, to: (CGFloat(b0), CGFloat(b1)))))
    return hex(r: r, g: g, b: b)
}

func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    guard lower <= upper else {
        return clamp(value, lower: upper, upper: lower)
    }
    return min(max(value, lower), upper)
}
