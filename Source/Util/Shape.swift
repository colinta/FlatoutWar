//
//  Shape.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

enum Shape {
    case Circle
    case Rect
    case Triangle
}

func nodeCorners(node: Node) -> [CGPoint]? {
    if let location = node.world?.convertPosition(node) {
        let size = node.size
        let rotation = node.zRotation

        if size.width == 0 && size.height == 0 {
            return [location]
        }

        let r = size.length / 2
        let a1 = rotation + size.angle
        let a3 = a1 + TAU_2
        let corner1 = location + CGPoint(r: r, a: a1)
        let corner3 = location + CGPoint(r: r, a: a3)

        if size.width == 0 || size.height == 0 {
            return [corner1, corner3]
        }

        let a4 = rotation - size.angle
        let a2 = a4 + TAU_2
        let corner2 = location + CGPoint(r: r, a: a2)
        let corner4 = location + CGPoint(r: r, a: a4)

        return [corner1, corner2, corner3, corner4]
    }
    return nil
}

func nodeSegments(node: Node) -> [Segment]? {
    if let corners = nodeCorners(node), last = corners.last {
        var prev = last
        var segments = [Segment]()
        for corner in corners {
            segments << Segment(p1: prev, p2: corner)
            prev = corner
        }
        return segments
    }
    return nil
}

func node(node: Node, touches other: Node) -> Bool {
    guard !node.distanceTo(other, within: 0.001) else { return true }
    guard node.distanceTo(other, within: other.outerRadius + node.outerRadius) else { return false }

    if let myCorners = nodeCorners(node), mySegments = nodeSegments(node),
        otherCorners = nodeCorners(other), otherSegments = nodeSegments(other)
    {
        // check corners
        if myCorners.count == 4 {
            let myArea = areaOf(myCorners[0], myCorners[1], myCorners[2], myCorners[3])
            for corner in otherCorners {
                if contains(node, worldPoint: corner, preCalc: (corners: myCorners, area: myArea)) {
                    return true
                }
            }
        }

        if otherCorners.count == 4 {
            let otherArea = areaOf(otherCorners[0], otherCorners[1], otherCorners[2], otherCorners[3])
            for corner in myCorners {
                if contains(other, worldPoint: corner, preCalc: (corners: otherCorners, area: otherArea)) {
                    return true
                }
            }
        }

        // check segments
        return mySegments.any { s1 in
            return otherSegments.any { s2 in
                return s1.intersects(s2)
            }
        }
    }
    return false
}

func contains(node: Node, worldPoint point: CGPoint, preCalc: (corners: [CGPoint], area: CGFloat)? = nil) -> Bool {
    if let preCalc = preCalc {
        let (corners, myArea) = preCalc
        let area = areaOf(point, corners[0], corners[1]) +
            areaOf(point, corners[1], corners[2]) +
            areaOf(point, corners[2], corners[3]) +
            areaOf(point, corners[3], corners[0])
        return abs(area - myArea) < 0.001
    }

    let myCorners = nodeCorners(node)
    if let myCorners = myCorners where myCorners.count == 4 {
        let myArea = areaOf(myCorners[0], myCorners[1], myCorners[2], myCorners[3])
        let area = areaOf(point, myCorners[0], myCorners[1]) +
            areaOf(point, myCorners[1], myCorners[2]) +
            areaOf(point, myCorners[2], myCorners[3]) +
            areaOf(point, myCorners[3], myCorners[0])
        return abs(area - myArea) < 0.001
    }
    else if let myCorners = myCorners where myCorners.count == 2 {
        return Segment(p1: myCorners[0], p2: myCorners[1]).intersects(Segment(p1: point, p2: point))
    }
    return false
}
