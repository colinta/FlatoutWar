//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: World {

    override func populateWorld() {
        let t = SKSpriteNode(id: .WhiteLetter("1", size: .Big), scale: .Zoomed)
        t.setScale(2)
        self << t
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
