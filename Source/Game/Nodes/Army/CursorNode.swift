////
///  CursorNode.swift
//

private var dScale: CGFloat = 1.5
private var dAlphaUp: CGFloat = 10
private var dAlphaDown: CGFloat = 4
private var dRotation: CGFloat = 0.7

class CursorNode: Node {
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                destAlpha = 1
                destScale = 1
                destScalePhase = xScale
            }
            else {
                destAlpha = 0
                destScale = 0
                destScalePhase = xScale
            }
        }
    }
    private var destAlpha: CGFloat?
    private var destScale: CGFloat?
    private var destScalePhase: CGFloat?
    private var sprite = SKSpriteNode(id: .Cursor)

    required init() {
        super.init()
        z = .Top
        alpha = 0
        setScale(0)
        self << sprite
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(_ dt: CGFloat) {
        guard xScale > 0 || destScale != nil else {
            return
        }
        sprite.zRotation += dRotation * dt

        if let destScale = destScale, let destScalePhase = destScalePhase {
            if let currentScale = moveValue(destScalePhase, towards: destScale, by: dScale * dt) {
                let spriteScale = easeOutElastic(time: currentScale)
                setScale(spriteScale)
                size = CGSize(80) * spriteScale
                self.destScalePhase = currentScale
            }
            else {
                self.destScale = nil
                self.destScalePhase = nil
            }
        }

        if let destAlpha = destAlpha {
            if let currentAlpha = moveValue(alpha, towards: destAlpha, up: dAlphaUp * dt, down: dAlphaDown * dt) {
                alpha = currentAlpha
            }
            else {
                self.destAlpha = nil
            }
        }
    }

}
