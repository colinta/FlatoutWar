////
///  WoodsLevel.swift
//

class WoodsLevel: Level {
    struct TreeInfo {
        let center: CGPoint
        let radius: CGFloat
        let alpha: CGFloat

        init(center: CGPoint) {
            let minRadius: CGFloat = 0.05
            let maxRadius: CGFloat = 0.1
            let radius = rand(min: minRadius, max: maxRadius)
            let minAlpha: CGFloat = 0.5
            let maxAlpha: CGFloat = 0.75
            let alpha = rand(min: minAlpha, max: maxAlpha)

            self.center = center
            self.radius = radius
            self.alpha = alpha
        }

        init(center: CGPoint, radius: CGFloat, alpha: CGFloat) {
            self.center = center
            self.radius = radius
            self.alpha = alpha
        }
    }

    required init() {
        super.init()
        levelSelect = .woods
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func populateWorld() {
        super.populateWorld()
        generateTrees()
    }

    func generateTree(info: TreeInfo) -> Node {
        let p = info.center * size / 2
        let r = info.radius * size.width
        let node = Node(at: p)

        let sprite = SKSpriteNode(id: .fillColorCircle(size: CGSize(r: r), color: GreenTreeColor))
        sprite.alpha = info.alpha
        sprite.z = .above
        node << sprite

        let wanderingComponent = WanderingComponent()
        wanderingComponent.wanderingRadius = 10
        wanderingComponent.centeredAround = p
        wanderingComponent.maxSpeed = 1
        node.addComponent(wanderingComponent)

        return node
    }

    func generateTrees() {
        var trees: [TreeInfo] = []

        do {
            let count = 9
            var y: CGFloat = -1.25
            let dy: CGFloat = -2 * y / CGFloat(count - 1)
            let xs: [CGFloat] = [0.9, 1.05, 1.2, 1.35]
            let centerDelta: CGFloat = 0.05
            trees += (0..<count).flatMap { (_: Int) -> [TreeInfo] in
                let treeColumn = xs.map { x -> TreeInfo in
                    let p = CGPoint(x, y) + CGPoint(r: rand(centerDelta), a: rand(TAU))
                    return TreeInfo(center: p)
                }
                y += dy
                return treeColumn
            }
        }

        do {
            let centers: [(Int, CGPoint)] = [
                (3, CGPoint(-1.1, -1)),
                (2, CGPoint(-1.1, 1)),
                (1, CGPoint(-0.8, 1.1)),
                (2, CGPoint(-0.75, -1.05)),
            ]
            let dr: CGFloat = 0.1
            for (count, center) in centers {
                count.times {
                    let p = (center + CGPoint(r: dr, a: rand(TAU)))
                    trees << TreeInfo(center: p)
                }
            }
        }

        for info in trees {
            self << generateTree(info: info)
        }
    }

}
