//
//  PathDrawingNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private enum PathSegment {
    case Start(CGPoint)
    case Line(CGPoint, CGPoint)
    case Quad(CGPoint, CGPoint, control: CGPoint)

    func pointAt(t: CGFloat) -> CGPoint {
        switch self {
        case let Start(pt): return pt
        case let Line(pt1, pt2):
            return pt1 + (pt2 - pt1) * t
        case let Quad(pt1, pt2, control):
            let m1 = pt1 + (control - pt1) * t
            let m2 = control + (pt2 - control) * t
            return m1 + (m2 - m1) * t
        }
    }
}

private func pointsToBezierPath(points: [CGPoint]) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    let segments = pointsToSegments(points)
    for segment in segments {
        switch segment {
        case let .Start(point):
            bezierPath.moveToPoint(point)
        case let .Line(_, point):
            bezierPath.addLineToPoint(point)
        case let .Quad(_, point, control):
            bezierPath.addQuadCurveToPoint(point, controlPoint: control)
        }
    }
    return bezierPath
}

private func pointsToSegments(points: [CGPoint]) -> [PathSegment] {
    var retVal: [PathSegment] = []

    var prevPoint: CGPoint?
    var prevDest: CGPoint?
    for point in points {
        if let prevPoint = prevPoint {
            let midPoint = CGPoint(
                x: (point.x + prevPoint.x) / 2,
                y: (point.y + prevPoint.y) / 2
            )

            if let prevDest = prevDest {
                retVal << .Quad(prevDest, midPoint, control: prevPoint)
            }
            else {
                retVal << .Line(prevPoint, midPoint)
            }
            prevDest = midPoint
        }
        else {
            retVal << .Start(point)
        }
        prevPoint = point
    }

    if let lastPoint = prevPoint, prevDest = prevDest {
        retVal << .Line(prevDest, lastPoint)
    }
    return retVal
}

private func segmentsToLengths(segments: [PathSegment]) -> [(PathSegment, CGFloat)] {
    var lengths: [(PathSegment, CGFloat)] = []
    for segment in segments {
        let length: CGFloat
        switch segment {
        case .Start:
            length = 0
        case let .Line(start, dest):
            length = start.distanceTo(dest)
        case let .Quad(start, dest, control):
            length = start.distanceTo(control) + control.distanceTo(dest)
        }
        lengths << (segment, length)
    }
    return lengths
}


class PathDrawingNode: Node {
    var pathFn: (t: CGFloat, v: CGFloat) -> CGPoint = { _ in return .zero }

    required init() {
        super.init()

        let touchComponent = TouchableComponent()
        var points: [CGPoint] = []
        let maxLength: CGFloat = 1000

        let sprite = SKSpriteNode(id: .None)
        sprite.anchorPoint = CGPoint.zero
        self << sprite
        touchComponent.on(.Down) { position in
            points << position
        }
        touchComponent.onDragged { prevPosition, position in
            points << position
            points = self.reducePointsToLength(points, max: maxLength)

            let path = pointsToBezierPath(points)
            sprite.textureId(.ColorPath(path: path, color: PowerupRed))
            sprite.position = path.bounds.origin
        }
        touchComponent.on(.Up) { position in
            let segments = pointsToSegments(points)
            let lengths = segmentsToLengths(segments)
            var adjustedLengths: [(segment: PathSegment, length: CGFloat, cummulative: CGFloat)] = []
            let totalLength: CGFloat = lengths.reduce(CGFloat(0)) { length, segmentInfo in
                let currentLength = length + segmentInfo.1
                adjustedLengths << (segmentInfo.0, segmentInfo.1, currentLength)
                return currentLength
            }

            let firstPoint = points.first ?? .zero
            let lastPoint = points.last ?? .zero
            self.pathFn = { time, velocity in
                // hack to return the totalLength and totalTime
                if time < 0 { return CGPoint(totalLength, totalLength / velocity) }
                // don't bother calculating for t=0
                if time == 0 { return firstPoint }

                let length = velocity * time
                guard length < totalLength else { return lastPoint }

                let segmentInfo = adjustedLengths.firstMatch { $0.cummulative > length }
                if let segmentInfo = segmentInfo {
                    let t = 1 - (segmentInfo.cummulative - length) / segmentInfo.length
                    return segmentInfo.segment.pointAt(t)
                }
                return .zero
            }
        }
        addComponent(touchComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func reducePointsToLength(points: [CGPoint], max maxLength: CGFloat) -> [CGPoint] {
        var retVal: [CGPoint] = []
        var totalLength: CGFloat = 0
        var index = points.count
        var prevPoint: CGPoint?
        while totalLength < maxLength {
            if index == 0 {
                break
            }
            index -= 1

            let point = points[index]
            if let prevPoint = prevPoint {
                let length = point.distanceTo(prevPoint)
                if totalLength + length > maxLength {
                    let radius = maxLength - totalLength
                    let angle = prevPoint.angleTo(point)
                    retVal.insert(prevPoint + CGPoint(r: radius, a: angle), atIndex: 0)
                    break
                }
                totalLength += length
            }

            retVal.insert(point, atIndex: 0)
            prevPoint = point
        }

        return retVal
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

}
