import CoreGraphics

// swiftc -swift-version 6 Source/Engine/Position.swift Source/Engine/ViewportLayout.swift \
//   Tests/ViewportLayoutTests.swift -o /tmp/FlatoutWarViewportTests && /tmp/FlatoutWarViewportTests
@main
struct ViewportLayoutTests {
    static func main() {
        let folded = layout(width: 678, height: 466, top: 0, left: 62, bottom: 21, right: 62)
        // Geometry and insets read from the running, fully opened Duo.
        let opened = layout(width: 951, height: 669, top: 0, left: 0, bottom: 34, right: 0)
        precondition(opened.worldScale > folded.worldScale)
        near(opened.worldScale, 951 / 667)

        // Repeated fold/unfold and rotation must not reuse a global scale or safe area.
        let rotated = layout(width: 678, height: 466, top: 0, left: 0, bottom: 21, right: 62)
        for viewport in [folded, opened, rotated, opened, folded] {
            verifyControls(in: viewport)
            near(viewport.worldSize.width * viewport.worldScale, viewport.viewBounds.width)
            near(viewport.worldSize.height * viewport.worldScale, viewport.viewBounds.height)
        }

        // Insets can change without a size change, and size can change without insets.
        let noInsets = layout(width: 951, height: 669, top: 0, left: 0, bottom: 0, right: 0)
        precondition(noInsets != opened)
        precondition(noInsets.worldScale == opened.worldScale)
        precondition(noInsets.uiBounds != opened.uiBounds)
        let resized = layout(width: 874, height: 402, top: 0, left: 0, bottom: 34, right: 0)
        precondition(resized.worldScale != opened.worldScale)
        verifyControls(in: resized)

        // Nonzero UIKit bounds origins must not shift the centered SpriteKit UI.
        let offset = ViewportLayout(viewBounds: CGRect(x: 10, y: 20, width: 951, height: 669),
                                    safeFrame: CGRect(x: 10, y: 20, width: 951, height: 635))
        precondition(offset.uiBounds == opened.uiBounds)
        print("Viewport tests passed: fold/unfold, rotation, independent inset/size updates, corner clearance")
    }

    private static func layout(width: CGFloat, height: CGFloat, top: CGFloat, left: CGFloat,
                               bottom: CGFloat, right: CGFloat) -> ViewportLayout {
        ViewportLayout(viewBounds: CGRect(x: 0, y: 0, width: width, height: height),
                       safeFrame: CGRect(x: left, y: top, width: width - left - right,
                                         height: height - top - bottom))
    }

    private static func verifyControls(in layout: ViewportLayout) {
        let bounds = layout.uiBounds
        let pause = Position.topRight(x: -40, y: -40).positionIn(bounds: bounds)
        let powerup = Position.topLeft(x: 40, y: -40).positionIn(bounds: bounds)
        let scale = layout.worldScale
        // Convert back to UIKit to verify both safe-area placement and scaling.
        near(layout.viewBounds.midX + pause.x * scale, layout.safeFrame.maxX - 40 * scale)
        near(layout.viewBounds.midY - pause.y * scale, layout.safeFrame.minY + 40 * scale)
        near(layout.viewBounds.midX + powerup.x * scale, layout.safeFrame.minX + 40 * scale)
        // Pause's 80-unit hit target is scaled to 0.75; power-ups have a 44-unit minimum.
        precondition(bounds.contains(CGRect(x: pause.x - 30, y: pause.y - 30, width: 60, height: 60)))
        precondition(bounds.contains(CGRect(x: powerup.x - 22, y: powerup.y - 22, width: 44, height: 44)))
    }

    private static func near(_ actual: CGFloat, _ expected: CGFloat) {
        precondition(abs(actual - expected) < 0.0001, "Expected \(expected), got \(actual)")
    }
}
