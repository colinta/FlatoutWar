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
        levelSelect = .Woods
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func populateWorld() {
        super.populateWorld()
        generateTrees()
    }

    func generateTrees() {
        guard let trees = (config as? WoodsLevelConfig)?.treeCenters else { return }

        for info in trees {
            let p = info.center * size / 2
            let r = info.radius * size.width
            let node = Node(at: p)

            let sprite = SKSpriteNode(id: .FillColorCircle(size: CGSize(r: r), color: GreenTreeColor))
            sprite.alpha = info.alpha
            sprite.z = .Above
            node << sprite

            let wanderingComponent = WanderingComponent()
            wanderingComponent.wanderingRadius = 10
            wanderingComponent.centeredAround = p
            wanderingComponent.maxSpeed = 1
            node.addComponent(wanderingComponent)

            self << node
        }
    }

}
