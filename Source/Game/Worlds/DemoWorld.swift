//
//  DemoWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DemoWorld: World {
    let playerNode = BasePlayerNode()

    override func populateWorld() {
        pauseable = false
        timeRate = 1

        defaultNode = playerNode
        self << playerNode

        let drone = DroneNode(at: CGPoint(100, 50))
        self << drone

        timeline.every(4, block: generateEnemyFormation(0))

        let percentNode = PercentNode(at: CGPoint(x: -50, y: 0))
        self << percentNode
        var complete: CGFloat = 0
        timeline.every(0.1) {
            complete += 0.01
            percentNode.complete = complete
        }

        let backButton = ButtonNode()
        let nextButton = ButtonNode()

        backButton.fixedPosition = .C(x: -27, y: 0)
        backButton.text = "<"
        backButton.size = CGSize(50)
        backButton.style = .Square
        backButton.visible = true
        ui << backButton

        nextButton.fixedPosition = .C(x: 27, y: 0)
        nextButton.text = ">"
        nextButton.size = CGSize(50)
        nextButton.style = .Square
        nextButton.visible = true
        ui << nextButton


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
    }

    // exp: 12
    func generateEnemyFormation(angle: CGFloat)() {
        let center = CGPoint(r: radius, a: angle)

        let enemyLeader = EnemyLeaderNode(at: center)
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
