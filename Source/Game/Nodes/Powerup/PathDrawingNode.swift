//
//  PathDrawingNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 2/4/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Path {

    func plot(time: CGFloat) -> (CGPoint, CGFloat) {
        return (.Zero, 0)
    }

}

private enum PathSegment {
    case Start(CGPoint)
    case Line(CGPoint)
    case Quad(CGPoint, control: CGPoint)
}

private func pointsToBezierPath(points: [CGPoint]) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    let segments = pointsToSegments(points)
    for segment in segments {
        switch segment {
        case let .Start(point):
            bezierPath.moveToPoint(point)
        case let .Line(point):
            bezierPath.addLineToPoint(point)
        case let .Quad(point, control):
            bezierPath.addQuadCurveToPoint(point, controlPoint: control)
        }
    }
    return bezierPath
}

private func pointsToSegments(points: [CGPoint]) -> [PathSegment] {
    var retVal: [PathSegment] = []

    var prevPoint: CGPoint?
    var isFirst = true
    for point in points {
        if let prevPoint = prevPoint {
            let midPoint = CGPoint(
                x: (point.x + prevPoint.x) / 2,
                y: (point.y + prevPoint.y) / 2
            )

            if isFirst {
                retVal << .Line(midPoint)
            }
            else {
                retVal << .Quad(midPoint, control: prevPoint)
            }
            isFirst = true
        }
        else {
            retVal << .Start(point)
        }
        prevPoint = point
    }

    if let lastPoint = prevPoint {
        retVal << .Line(lastPoint)
    }
    return retVal
}

private func segmentsToLengths(segments: [PathSegment]) -> [(PathSegment, CGFloat)] {
    var prevPoint: CGPoint?
    var lengths: [(PathSegment, CGFloat)] = []
    for segment in segments {
        let length: CGFloat
        switch segment {
        case let .Start(point):
            prevPoint = point
            length = 0
        case let .Line(point):
            guard let start = prevPoint else { continue }

            length = start.distanceTo(point)
            prevPoint = start
        case let .Quad(point, control):
            guard let start = prevPoint else { continue }

            length = start.distanceTo(control) + control.distanceTo(point)
            prevPoint = point
        }
        lengths << (segment, length)
    }
    return lengths
}

private func interpolateCurve(start start: CGPoint, dest: CGPoint, control: CGPoint, resolution: Int) -> [CGPoint] {
    var retVal: [CGPoint] = []
    let deltaStart = control - start
    let deltaControl = dest - control
    let midLeft: (CGFloat) -> CGPoint = { t in
        return start + deltaStart * t
    }
    let midRight: (CGFloat) -> CGPoint = { t in
        return control + deltaControl * t
    }
    let quad: (CGFloat, CGPoint, CGPoint) -> CGPoint = { t, midLeft, midRight in
        let delta = midRight - midLeft
        return midLeft + delta * t
    }
    let deltaT = 1 / CGFloat(resolution)
    var t: CGFloat = 0
    while t < 1 {
        t = min(1, t + deltaT)
        retVal << quad(t, midLeft(t), midRight(t))
    }
    retVal << dest
    return retVal
}

private func interpolatePoints(start: CGPoint, _ dest: CGPoint) -> [CGPoint] {
    var retVal: [CGPoint] = []
    let r: CGFloat = 0.25
    let length = start.distanceTo(dest)
    let angle = start.angleTo(dest)
    var prevPoint = start
    let segment = CGPoint(r: r, a: angle)
    Int(length / r).times {
        prevPoint = prevPoint + segment
        retVal << prevPoint
    }
    retVal << dest
    return retVal
}

class PathDrawingNode: Node {
    var pathFn: (CGFloat) -> CGPoint = { _ in return .Zero }

    required init() {
        super.init()

        let touchComponent = TouchableComponent()
        var points: [CGPoint] = []
        let maxLength: CGFloat = 1000

        let sprite = SKSpriteNode(id: .None)
        sprite.anchorPoint = CGPoint.Zero
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
            let totalLength: CGFloat = lengths.reduce(CGFloat(0)) { length, segmentInfo in
                return length + segmentInfo.1
            }

            self.pathFn = { time, velocity in
                if time <= 0 { return points.first ?? .Zero }
                if time >= 1 { return points.last ?? .Zero }

                let index = t * totalLength
                let i = Int(floor(index))
                let t = index - CGFloat(i)
                let s = segments[i]
                return .Zero
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
