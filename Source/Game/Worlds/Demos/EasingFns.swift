////
///  EasingFns.swift
//

class EasingFns: World {
    var dots: [Node] = []
    var easings: [Easing] = [
        .Custom({ (_, initial, _) in
            return initial
        }),
        .Linear,
        .EaseInBack,
        .EaseInElastic,
        .EaseOutCubic,
        .EaseOutElastic,
        .EaseOutExpo,
    ]
    var easingIndex = 0

    override func populateWorld() {
        moveCamera(from: CGPoint(y: 100))

        let count = 100
        for i in 0...100 {
            let x = -CGFloat(3 * count) / 2 + 3 * CGFloat(i)
            let node = Dot(at: CGPoint(x: x))
            dots << node
            self << node
        }

        applyFunction(easings[easingIndex])
    }

    func applyFunction(fn: Easing) {
        for (i, node) in dots.enumerate() {
            let time = CGFloat(i) / CGFloat(dots.count)
            let x = interpolate(CGFloat(i), from: (0, CGFloat(dots.count)), to: (-100, 100))
            let y = fn.ease(time: time, initial: 0, final: 200)
            node.moveTo(CGPoint(x, y), duration: 1)
        }
    }

    override func worldTouchBegan(id: NSObject, worldLocation: CGPoint) {
        super.worldTouchBegan(id, worldLocation: worldLocation)
        easingIndex = (easingIndex + 1) % easings.count
        applyFunction(easings[easingIndex])
    }

}
