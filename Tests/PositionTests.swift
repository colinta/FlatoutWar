import CoreGraphics

// Run from the repository root:
// swiftc -swift-version 6 Source/Engine/Position.swift Tests/PositionTests.swift \
//   -o /tmp/FlatoutWarPositionTests && /tmp/FlatoutWarPositionTests
@main
struct PositionTests {
    static func main() {
        let size = CGSize(width: 874, height: 402)
        let fullBounds = CGRect(x: -437, y: -201, width: 874, height: 402)
        let anchors: [(Position, CGPoint)] = [
            (.topLeft(x: 20, y: -20), CGPoint(x: -417, y: 181)),
            (.top(x: 0, y: -20), CGPoint(x: 0, y: 181)),
            (.topRight(x: -20, y: -20), CGPoint(x: 417, y: 181)),
            (.left(x: 20, y: 0), CGPoint(x: -417, y: 0)),
            (.center(x: 5, y: -5), CGPoint(x: 5, y: -5)),
            (.right(x: -20, y: 0), CGPoint(x: 417, y: 0)),
            (.bottomLeft(x: 20, y: 30), CGPoint(x: -417, y: -171)),
            (.bottom(x: 0, y: 30), CGPoint(x: 0, y: -171)),
            (.bottomRight(x: -20, y: 30), CGPoint(x: 417, y: -171))
        ]
        for (position, expected) in anchors {
            check(position.positionIn(screenSize: size), expected)
            check(position.positionIn(bounds: fullBounds), expected)
        }

        // Asymmetric insets: left 62, right 0, bottom 21, top 0.
        let safeBounds = CGRect(x: -375, y: -180, width: 812, height: 381)
        check(Position.topLeft(x: 20, y: -20).positionIn(bounds: safeBounds), CGPoint(x: -355, y: 181))
        check(Position.topRight(x: -20, y: -20).positionIn(bounds: safeBounds), CGPoint(x: 417, y: 181))
        check(Position.center(x: 0, y: 0).positionIn(bounds: safeBounds), CGPoint(x: 31, y: 10.5))
        check(Position.bottomRight(x: -20, y: 30).positionIn(bounds: safeBounds), CGPoint(x: 417, y: -150))

        // The other landscape orientation puts the cutout on the right.
        let rotatedBounds = CGRect(x: -437, y: -180, width: 812, height: 381)
        check(Position.topRight(x: -20, y: -20).positionIn(bounds: rotatedBounds), CGPoint(x: 355, y: 181))
        check(Position.topLeft(x: 20, y: -70).positionIn(bounds: rotatedBounds), CGPoint(x: -417, y: 131))

        // Safe bounds have already been converted to UI units. Margins are not scaled twice.
        let scaledBounds = CGRect(x: -187.5, y: -90, width: 406, height: 190.5)
        check(Position.topLeft(x: 20, y: -20).positionIn(bounds: scaledBounds), CGPoint(x: -167.5, y: 80.5))
        check(Position.topRight(x: -20, y: -20).positionIn(bounds: scaledBounds), CGPoint(x: 198.5, y: 80.5))
        print("Position tests passed (26 checks)")
    }

    private static func check(_ actual: CGPoint, _ expected: CGPoint) {
        precondition(abs(actual.x - expected.x) < 0.0001 && abs(actual.y - expected.y) < 0.0001,
                     "Expected \(expected), got \(actual)")
    }
}
