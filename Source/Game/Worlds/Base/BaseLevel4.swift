//
//  BaseLevel4.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseLevel4: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel4Config() }
    override func tutorial() -> Tutorial { return DroneTutorial() }

    override func populateWorld() {
        super.populateWorld()

        for node in config.storedPlayers {
            customizeNode(node)
            self << node
        }

        moveCamera(to: CGPoint(150, 50), duration: 2)
        beginWave1(at: 4)
        beginWave2(at: 50)
        beginWave3(at: 90)
    }

    override func nextLevel() -> BaseLevel {
        return BaseLevel5()
    }

    func beginWave1(at startTime: CGFloat) {
        timeline.every(0.39, startAt: startTime, times: 10, block: generateEnemyPair(rand(min: -size.angle, max: TAU_4)))
        timeline.every(0.39, startAt: startTime + 15, times: 10, block: generateEnemyPair(rand(min: -size.angle, max: TAU_4)))
        timeline.every(0.39, startAt: startTime + 28, times: 10, block: generateEnemyPair(rand(min: -size.angle, max: TAU_4)))
    }

    func beginWave2(at startTime: CGFloat) {
        timeline.every(6...8, startAt: startTime, times: 4) {
            let angle: CGFloat = rand(min: -self.size.angle, max: TAU_4)
            self.generateBigJetWithFollowers(angle, spread: 0)()
        }
    }

    func beginWave3(at startTime: CGFloat) {
        timeline.at(startTime) {
            self.moveCamera(to: CGPoint(200, 75), zoom: 0.75, duration: 3)
        }
        timeline.at(startTime + 3, block: generateGiant(size.angle))
        timeline.at(startTime + 4, block: generateGiant(size.angle - TAU_16))
        timeline.every(2, startAt: startTime, times: 10, block: generateEnemy(rand(±size.angle)))
    }

}
