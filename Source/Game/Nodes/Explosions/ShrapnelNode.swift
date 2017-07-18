////
///  ShrapnelNode.swift
//

class ShrapnelNode: Node {

    required init(type: ImageIdentifier, size: ImageIdentifier.Size) {
        super.init()
        self << SKSpriteNode(id: .enemyShrapnel(type, size: size))
    }

    func setupAround(node: Node, at location: CGPoint? = nil,
            rotateSpeed: CGFloat? = nil,
            distance: CGFloat? = nil) {
        position = location ?? node.position
        zRotation = node.zRotation

        let duration: CGFloat = 0.5

        let rotate = KeepRotatingComponent()
        if let rotateSpeed = rotateSpeed {
            rotate.rate = rotateSpeed
        }
        else {
            rotate.rate = rand(min: 1, max: 2)
        }
        addComponent(rotate)

        let move = MoveToComponent()
        let dest: CGPoint
        if let distance = distance {
            dest = CGPoint(r: distance, a: rand(TAU))
        }
        else {
            let minDist: CGFloat = node.radius * 3
            let maxDist: CGFloat = node.radius * 6
            dest = CGPoint(r: rand(min: minDist, max: maxDist), a: rand(TAU))
        }
        move.target = node.position + dest
        move.duration = duration
        addComponent(move)

        let fade = FadeToComponent()
        fade.target = 0
        fade.duration = duration
        fade.removeNodeOnFade()
        addComponent(fade)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
