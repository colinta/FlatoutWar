////
///  Playground.swift
//

class Playground: World {

    override func populateWorld() {
        let text = TextNode()
        text.setScale(1.5)
        text.text = "2DIM"
        self << text
    }

    override func worldShook() {
    }

    override func update(dt: CGFloat) {
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
