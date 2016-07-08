class LevelCompleteBox: Node {
    override var size: CGSize {
        didSet { updateSprite() }
    }
    var complete: CGFloat = 0 {
        didSet { updateSprite() }
    }
    let box = SKSpriteNode()

    required init() {
        super.init()

        self << box
        z = .Bottom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateSprite() {
        let boxHeight = complete * size.height
        box.position.y = -(size.height - boxHeight) / 2

        let color: Int
        if complete >= 1 {
            color = 0xA0D3A0 // green
        }
        else {
            let red: (CGFloat, CGFloat)
            let green: (CGFloat, CGFloat)
            let blue: (CGFloat, CGFloat)
            if complete < 0.5 {
                let target = 0xA83846  // red
                red = (0, 2 * CGFloat(target >> 16 & 0xff))
                green = (0, 2 * CGFloat(target >> 8 & 0xff))
                blue = (0, 2 * CGFloat(target & 0xff))
            }
            else {
                let target = 0xF1EC3E  // yellow
                red = (0, CGFloat(target >> 16 & 0xff))
                green = (0, CGFloat(target >> 8 & 0xff))
                blue = (0, CGFloat(target & 0xff))
            }
            color = Int(
                red: Int(interpolate(complete, from: (0, 1), to: red)),
                green: Int(interpolate(complete, from: (0, 1), to: green)),
                blue: Int(interpolate(complete, from: (0, 1), to: blue))
            )
        }
        box.textureId(.FillColorBox(size: CGSize(size.width, boxHeight), color: color))
    }
}
