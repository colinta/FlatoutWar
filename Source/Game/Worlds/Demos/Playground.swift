//
//  Playground.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Playground: DemoWorld {

    override func populateWorld() {
        super.populateWorld()
        timeRate = 1

        let drone = DroneNode(at: CGPoint(100, 50))
        drone.draggableComponent?.maintainDistance(100, around: playerNode)
        self << drone

        let soldier = EnemySoldierNode()
        soldier.position = outsideWorld(soldier, angle: TAU_2)
        soldier.rotateTowards(playerNode)
        self << soldier

        timeline.every(0.3, startAt: 3) {
            let jet = EnemyJetNode()
            jet.position = self.outsideWorld(jet, angle: TAU_2)
            jet.flyingComponent?.target = self.playerNode
            if let location = jet.flyingComponent?.currentFlyingTarget {
                jet.rotateTowards(point: location)
            }
            self << jet
        }

        // timeline.every(4, block: generateEnemyFormation(0))

        // let minX = -size.width / 2 + 20, maxX = size.width / 2 - 20
        // let minY = -size.height / 2 + 20
        // var x: CGFloat = minX
        // var y: CGFloat = minY
        // for i in 0...90 {
        //     let id: ImageIdentifier = .HueLine(length: CGFloat(i) / 10, hue: 20)
        //     let image = Artist.generate(id)

        //     x += image.size.width + 10
        //     if x > maxX {
        //         x = minX
        //         y += image.size.height + 10
        //     }

        //     let sprite = SKSpriteNode(id: id)
        //     sprite.position = CGPoint(x, y)
        //     self << sprite
        // }

        let closeButton = Button(fixed: .TopRight(x: -15, y: -15))
        closeButton.setScale(0.5)
        closeButton.text = "×"
        closeButton.size = CGSize(60)
        closeButton.onTapped { _ in
            self.director?.presentWorld(LevelSelectWorld())
        }
        ui << closeButton
    }

    func generateEnemyFormation(angle: CGFloat)() {
        let enemyLeader = EnemyLeaderNode()
        let center = outsideWorld(enemyLeader, angle: angle)
        enemyLeader.rotateTowards(playerNode)
        self << enemyLeader

        let dist = CGFloat(25)
        let left = CGVector(r: dist, a: angle + TAU_4)
        let right = CGVector(r: dist, a: angle - TAU_4)
        let back = center + CGVector(r: dist, a: angle)
        let back2 = center + CGVector(r: 2 * dist, a: angle)

        let origins = [
            center + left,
            center + right,
            back + left,
            back,
            back + right,
            back2 + left,
            back2,
            back2 + right,
        ]
        for origin in origins {
            let enemy = EnemySoldierNode(at: origin)
            enemy.rotateTowards(playerNode)
            enemy.follow(enemyLeader)
            self << enemy
        }
    }

}
