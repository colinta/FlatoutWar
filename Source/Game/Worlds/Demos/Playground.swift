////
///  Playground.swift
//

class Playground: World {

    override func populateWorld() {
        let boss = WoodsBossNode(at: CGPoint(x: -200))
        boss.zRotation = TAU_4
        self << boss

        let player = BasePlayerNode(at: CGPoint(x: 200))
        defaultNode = player
        self << player
    }

    func generateTransport() {
        timeline.every(12, times: 8) {
            let xs: CGFloat = ±1
            let start = CGPoint(
                x: xs * self.size.width * rand(min: 0.3, max: 0.4),
                y: self.size.height / 2 + 40
                )
            let dest = CGPoint(
                x: xs * self.size.width * rand(min: 0.3, max: 0.4),
                y: -start.y
                )
            self.timeline.after(time: 3) {
                let transport = EnemyJetTransportNode()
                var control = (start + dest) / 2
                if start.x > 0 {
                    control += CGPoint(x: self.size.height / 4)
                }
                else {
                    control -= CGPoint(x: self.size.height / 4)
                }

                let arcTo = transport.arcTo(dest, start: start, speed: 50)
                arcTo.control = control
                arcTo.onArrived {
                    transport.removeFromParent()
                }

                transport.transportPayload([
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemySoldierNode(),
                    EnemyLeaderNode(),
                ])

                self << transport
            }
        }
    }

    private func generateEnemies() {
        let angle: CGFloat = [
            0, 1, 2, 3, 4, 5, 6, 7, 8
        ].rand()! * TAU_8
        for time in [0,1,2] {
            delay(TimeInterval(time)) {
                let enemyNode = EnemySoldierNode()
                enemyNode.position = CGPoint(r: self.outerRadius, a: angle)
                self << enemyNode
            }
        }
        delay(2) {
            self.onNoMoreEnemies {
                self.generateEnemies()
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
            n.font = .big
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
        closeButton.onTapped {
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
            n.setRotation(angle)
            self << n
        }
    }

}
