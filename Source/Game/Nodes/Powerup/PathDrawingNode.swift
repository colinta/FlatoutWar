////
///  PathDrawingNode.swift
//

private enum PathSegment {
    case start(CGPoint)
    case line(CGPoint, CGPoint)
    case quad(CGPoint, CGPoint, control: CGPoint)

    func pointAt(time t: CGFloat) -> CGPoint {
        switch self {
        case let .start(pt): return pt
        case let .line(pt1, pt2):
            return pt1 + (pt2 - pt1) * t
        case let .quad(pt1, pt2, control):
            let m1 = pt1 + (control - pt1) * t
            let m2 = control + (pt2 - control) * t
            return m1 + (m2 - m1) * t
        }
    }
}

private func pointsToBezierPath(_ points: [CGPoint]) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    let segments = pointsToSegments(points)
    for segment in segments {
        switch segment {
        case let .start(point):
            bezierPath.move(to: point)
        case let .line(_, point):
            bezierPath.addLine(to: point)
        case let .quad(_, point, control):
            bezierPath.addQuadCurve(to: point, controlPoint: control)
        }
    }
    return bezierPath
}

private func pointsToSegments(_ points: [CGPoint]) -> [PathSegment] {
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
                retVal << .quad(prevDest, midPoint, control: prevPoint)
            }
            else {
                retVal << .line(prevPoint, midPoint)
            }
            prevDest = midPoint
        }
        else {
            retVal << .start(point)
        }
        prevPoint = point
    }

    if let lastPoint = prevPoint, let prevDest = prevDest {
        retVal << .line(prevDest, lastPoint)
    }
    return retVal
}

private func segmentsToLengths(_ segments: [PathSegment]) -> [(PathSegment, CGFloat)] {
    var lengths: [(PathSegment, CGFloat)] = []
    for segment in segments {
        let length: CGFloat
        switch segment {
        case .start:
            length = 0
        case let .line(start, dest):
            length = start.distanceTo(dest)
        case let .quad(start, dest, control):
            length = start.distanceTo(control) + control.distanceTo(dest)
        }
        lengths << (segment, length)
    }
    return lengths
}


class PathDrawingNode: Node {
    var pathFn: ((t: CGFloat, v: CGFloat)) -> CGPoint = { _ in return .zero }

    required init() {
        super.init()

        let touchComponent = TouchableComponent()
        var points: [CGPoint] = []
        let maxLength: CGFloat = 1000

        let sprite = SKSpriteNode(id: .none)
        sprite.anchorPoint = CGPoint.zero
        self << sprite
        touchComponent.on(.down) { position in
            points << position
        }
        touchComponent.onDragged { prevPosition, position in
            points << position
            points = self.reducePointsToLength(points, max: maxLength)

            let path = pointsToBezierPath(points)
            sprite.textureId(.colorPath(path: path, color: PowerupRed))
            sprite.position = path.bounds.origin
        }
        touchComponent.on(.up) { position in
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
            self.pathFn = { (arg) in
                // hack to return the totalLength and totalTime

                let (time, velocity) = arg
                if time < 0 { return CGPoint(totalLength, totalLength / velocity) }
                // don't bother calculating for t=0
                if time == 0 { return firstPoint }

                let length = velocity * time
                guard length < totalLength else { return lastPoint }

                let segmentInfo = adjustedLengths.firstMatch { $0.cummulative > length }
                if let segmentInfo = segmentInfo {
                    let t = 1 - (segmentInfo.cummulative - length) / segmentInfo.length
                    return segmentInfo.segment.pointAt(time: t)
                }
                return .zero
            }
        }
        addComponent(touchComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func reducePointsToLength(_ points: [CGPoint], max maxLength: CGFloat) -> [CGPoint] {
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
                    retVal.insert(prevPoint + CGPoint(r: radius, a: angle), at: 0)
                    break
                }
                totalLength += length
            }

            retVal.insert(point, at: 0)
            prevPoint = point
        }

        return retVal
    }

}
