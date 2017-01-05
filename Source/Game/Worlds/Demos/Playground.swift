////
///  Playground.swift
//

class Playground: World {
    let cannon = CannonNode(at: CGPoint(r: 50, a: TAU_3_4))
    let silo = MissleSiloNode(at: CGPoint(r: 50, a: TAU_4))
    let laser = LaserNode(at: CGPoint(r: 50, a: TAU_8))
    let drone = DroneNode(at: CGPoint(r: 50, a: TAU_5_8))
    let shotgun = ShotgunNode(at: CGPoint(r: 50, a: TAU_7_8))

    override func populateWorld() {
        channel?.gain = 0

        let playerNode = BasePlayerNode()
        playerNode.rotateTo(TAU_2)
        playerNode.firingComponent?.enabled = false
        playerNode.targetingComponent?.enabled = false
        self << playerNode

        shotgun.radarUpgrade = .True
        shotgun.bulletUpgrade = .True
        shotgun.movementUpgrade = .True

        cannon.draggableComponent?.maintainDistance(100, around: playerNode)
        silo.draggableComponent?.maintainDistance(100, around: playerNode)
        laser.draggableComponent?.maintainDistance(100, around: playerNode)
        drone.draggableComponent?.maintainDistance(100, around: playerNode)
        shotgun.draggableComponent?.maintainDistance(100, around: playerNode)

        defaultNode = playerNode

        generateNext([shotgun], shotgun)
    }

    private func generateNext(_ nodes: [Node], _ currentNode: Node) {
        self << currentNode

        for time in [0,1,2] {
            delay(TimeInterval(time)) {
                let enemyNode = EnemySoldierNode()
                enemyNode.name = "soldier"
                enemyNode.position = CGPoint(r: self.outerRadius, a: 0)
                self << enemyNode
            }
        }

        delay(2) {
            let nextNode = nodes[0]
            let newNodes = Array(nodes[1..<nodes.count] + [currentNode])
            self.onNoMoreEnemies {
                delay(2) {
                    currentNode.removeFromParent(reset: false)
                    self.generateNext(newNodes, nextNode)
                }
            }
        }
    }

    override func worldShook() {
    }

    override func update(_ dt: CGFloat) {
    }

    func letters() {
        let letters = [
            "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V",
            "W","X","Y","Z","0","1","2","3","4","5","6","7","8","9",
        ]
        let dx: CGFloat = 50
        let dy: CGFloat = 30
        let x0: CGFloat = dx * -2.5
        let y0: CGFloat = dy * -2.5
        var x: CGFloat = x0
        var y: CGFloat = y0
        for letter in letters {
            let n = TextNode(at: CGPoint(x, y))
            n.font = .Big
            n.text = letter
            n.zRotation = TAU_4
            self << n

            if y < y0 + dy * 5 {
                y += dy
            }
            else {
                x += dx
                y = y0
            }
        }
    }

    func diamond() {
        let closeButton = CloseButton()
        closeButton.onTapped { _ in
            self.director?.presentWorld(MainMenuWorld())
        }
        ui << closeButton

        let r1: CGFloat = 10
        let r2: CGFloat = 17.320508075688775
        let locations: [(CGPoint, CGFloat)] = [
            (CGPoint(r: r1, a: 0), 0),
            (CGPoint(r: r1, a: TAU_6), TAU_6),
            (CGPoint(r: r1, a: TAU_3), TAU_3),
            (CGPoint(r: r1, a: TAU_2), TAU_2),
            (CGPoint(r: r1, a: TAU_2_3), TAU_2_3),
            (CGPoint(r: r1, a: TAU_5_6), TAU_5_6),

            (CGPoint(r: r2, a: 1 * TAU_12), 4 * TAU_12),
            (CGPoint(r: r2, a: 3 * TAU_12), 6 * TAU_12),
            (CGPoint(r: r2, a: 5 * TAU_12), 8 * TAU_12),
            (CGPoint(r: r2, a: 7 * TAU_12), 10 * TAU_12),
            (CGPoint(r: r2, a: 9 * TAU_12), 12 * TAU_12),
            (CGPoint(r: r2, a: 11 * TAU_12), 14 * TAU_12),
        ]

        for (position, angle) in locations {
            let n = EnemyDiamondNode(at: position)
            n.rotateTo(angle)
            self << n
        }
    }

}
