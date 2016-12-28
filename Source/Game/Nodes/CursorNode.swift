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

    required init?(coder: NSCoder) {
        isSelected = coder.decode(key: "selected") ?? false
        super.init(coder: coder)
        sprite = coder.decode(key: "sprite") ?? sprite
        destAlpha = coder.decodeCGFloat(key: "destAlpha")
        destScale = coder.decodeCGFloat(key: "destScale")
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
        encoder.encode(isSelected, forKey: "selected")
        encoder.encode(sprite, forKey: "sprite")
        if let destAlpha = destAlpha {
            encoder.encode(destAlpha, forKey: "destAlpha")
        }
        if let destScale = destScale {
            encoder.encode(destScale, forKey: "destScale")
        }
    }

    override func update(_ dt: CGFloat) {
        guard xScale > 0 || destScale != nil else {
            return
        }
        sprite.zRotation += dRotation * dt

        if let destScale = destScale, let destScalePhase = destScalePhase {
            if let currentScale = moveValue(destScalePhase, towards: destScale, by: dScale * dt) {
                let spriteScale = easeOutElastic(time: currentScale)
                setScale(spriteScale)
                size = sprite.size
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
