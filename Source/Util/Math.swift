//
//
//  Math.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/14/15.
//  Copyright © 2015 colinta. All rights reserved.
//

let M_EPSILON: CGFloat = 0.00872664153575897

let TAU = CGFloat(2 * M_PI)
let TAU_2 = CGFloat(M_PI)

let TAU_3_4 = CGFloat(3 * M_PI / 2)
let TAU_4 = CGFloat(M_PI / 2)

let TAU_8 = CGFloat(M_PI / 4)
let TAU_3_8 = CGFloat(3 * M_PI / 4)
let TAU_5_8 = CGFloat(5 * M_PI / 4)
let TAU_7_8 = CGFloat(7 * M_PI / 4)

let TAU_16 = CGFloat(M_PI / 8)

func normalizeAngle(var angle: CGFloat) -> CGFloat {
    while angle < 0 {
        angle += TAU
    }
    while angle >= TAU {
        angle -= TAU
    }
    return angle
}

func deltaAngle(current: CGFloat, destAngle: CGFloat) -> CGFloat {
    let ccw = normalizeAngle(destAngle - current)
    let cw = normalizeAngle(current - destAngle)
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

func angleTowards(destAngle: CGFloat, fromAngle current: CGFloat, by amt: CGFloat) -> CGFloat? {
    let delta = deltaAngle(current, destAngle: destAngle)
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

func println(str: String) { print(str) }

func interpolate(x: CGFloat, from f: (CGFloat, CGFloat), to: (CGFloat, CGFloat)) -> CGFloat {
    let a1 = f.0,
        a2 = f.1,
        b1 = to.0,
        b2 = to.1
    guard a1 != a2 else { return b1 }

    return (b2 - b1) / (a2 - a1) * (x - a1) + b1
}

func areaOf(a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
    let sum = a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)
    return CGFloat(abs(sum) / 2.0)
}

func areaOf(a: CGPoint, _ b: CGPoint, _ c: CGPoint, _ d: CGPoint) -> CGFloat {
    return areaOf(a, b, c) + areaOf(c, d, a)
}
