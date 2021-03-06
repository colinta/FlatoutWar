////
///  BezierPaths.swift
//

class BezierPaths: World {
    var pts: [CGPoint] = []
    var sprite = SKSpriteNode(id: .none)
    var dots: [Node] = []
    var touchDots: [Node] = []
    var time: CGFloat = 0
    var addDots = true
    var rate: CGFloat = 0.2

    override func populateWorld() {
        sprite.anchorPoint = .zero
        self << sprite
    }

    func clear() {
        addDots = true
        time = 0
        for dot in dots {
            dot.removeFromParent()
        }
        dots = []
    }

    override func update(_ dt: CGFloat) {
        if time >= 1 {
            addDots = false
            time = 0
        }

        time += dt * rate
        if time > 1 { time = 1 }

        let path = UIBezierPath()
        var pointCount = pts.count
        var newPoints = pts
        while pointCount > 1 {
            var segments: [(CGPoint, CGPoint)] = []
            var prevPoint: CGPoint?
            for point in newPoints {
                if let prevPoint = prevPoint {
                    segments << (prevPoint, point)
                }
                prevPoint = point
            }

            newPoints = []
            var isFirst = true
            for segment in segments {
                let point = (segment.0 + (segment.1 - segment.0) * time)
                newPoints << point

                if isFirst {
                    path.move(to: point)
                }
                else {
                    path.addLine(to: point)
                }
                isFirst = false
            }
            pointCount = newPoints.count
        }

        if let point = newPoints.first, addDots {
            let dot = Dot(at: point)
            dots << dot
            self << dot
        }

        sprite.textureId(.colorPath(path: path, color: PowerupRed))
        sprite.position = path.bounds.origin
    }

    override func worldShook() {
        clear()

        pts = []
        for dot in touchDots {
            dot.removeFromParent()
        }
        touchDots = []
    }

    override func worldTouchEnded(_ id: NSObject, worldLocation: CGPoint) {
        super.worldTouchEnded(id, worldLocation: worldLocation)

        clear()
        pts << worldLocation

        let dot = Dot(at: worldLocation)
        touchDots << dot
        self << dot
    }

}
