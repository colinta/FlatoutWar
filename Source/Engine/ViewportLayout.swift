import CoreGraphics

// Geometry belongs to a scene's current view, never UIScreen.main. In particular,
// a fold/unfold can change the view size and safe area independently.
struct ViewportLayout: Equatable {
    let viewBounds: CGRect
    let safeFrame: CGRect

    var worldScale: CGFloat {
        max(1, min(viewBounds.width / 667, viewBounds.height / 375))
    }

    var worldSize: CGSize {
        CGSize(width: viewBounds.width / worldScale, height: viewBounds.height / worldScale)
    }

    // UIKit is top-left-origin, while the scene is centered and y-up. Calculating
    // directly avoids SKView coordinate transforms lagging a resize by a frame.
    var uiBounds: CGRect {
        CGRect(x: (safeFrame.minX - viewBounds.midX) / worldScale,
               y: (viewBounds.midY - safeFrame.maxY) / worldScale,
               width: safeFrame.width / worldScale,
               height: safeFrame.height / worldScale)
    }
}
