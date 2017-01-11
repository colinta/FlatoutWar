////
///  PercentBar.swift
//

class PercentBar: Node {
    let sprite = SKSpriteNode()
    let minSprite = SKSpriteNode()

    var style: PercentStyle = .Default { didSet { updateSprite() } }
    var isComplete: Bool { return complete == 1 }
    var isZero: Bool { return complete == 0 }
    var complete: CGFloat = 0 { didSet {
        if complete < 0 || complete > 1 {
            complete = min(max(complete, 0), 1)
        }
        else {
            updateSprite()
        }
    } }
    var minimum: CGFloat? { didSet {
        updateSprite()
    } }

    private func updateSprite() {
        sprite.textureId(.Percent(Int(round(min(max(complete, 0), 1) * 100)), style: style))
        size = sprite.size

        if let minimum = minimum {
            let x = size.width * (min(max(minimum, 0), 1) - 0.5)
            minSprite.position.x = x
            minSprite.textureId(.ColorLine(length: size.height * 2, color: style.color))
        }
        else {
            minSprite.textureId(.None)
        }
    }

    required init() {
        super.init()
        self << sprite
        self << minSprite
        minSprite.zRotation = TAU_4

        updateSprite()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
