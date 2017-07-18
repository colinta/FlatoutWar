////
///  Line.swift
//

class Line: Node {
    let sprite = SKSpriteNode()

    convenience init(segment: Segment, color: Int = WhiteColor) {
        self.init(from: segment.p1, to: segment.p2, color: color)
    }

    required init(from p1: CGPoint, to p2: CGPoint, color: Int = WhiteColor) {
        super.init()
        position = p1
        zRotation = p1.angleTo(p2)
        let length = p1.distanceTo(p2)
        sprite.textureId(.colorLine(length: length, color: color))
        sprite.anchorPoint = CGPoint(0, 0.5)
        self << sprite
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    required init() {
        fatalError("init() has not been implemented")
    }

}
