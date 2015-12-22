//
//  CGVectorExt.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/25/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension CGVector {

    init(r: CGFloat, a: CGFloat) {
        dx = r * cos(a)
        dy = r * sin(a)
    }

}

func +(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(
        dx: lhs.dx + rhs.dx,
        dy: lhs.dy + rhs.dy
        )
}

func *(lhs: CGVector, rhs: CGFloat) -> CGVector { return rhs * lhs }
func *(lhs: CGFloat, rhs: CGVector) -> CGVector {
    return CGVector(
        dx: lhs * rhs.dx,
        dy: lhs * rhs.dy
        )
}

func +(lhs: CGVector, rhs: CGPoint) -> CGPoint { return rhs + lhs }
func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(
        x: lhs.x + rhs.dx,
        y: lhs.y + rhs.dy
        )
}
