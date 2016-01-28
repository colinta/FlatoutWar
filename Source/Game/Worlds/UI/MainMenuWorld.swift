//
//  MainMenuWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/27/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class MainMenuWorld: World {

    override func populateWorld() {
        pauseable = false

        let textNode = TextNode(at: CGPoint(x: 0, y: 100))
        textNode.text = "FLATOUT WAR"
        self << textNode

        let howMany: Int = rand(8...15)
        howMany.times {
            let enemyNode = EnemySoldierNode(
                at: CGPoint(
                    x: rand(min: -size.width / 2, max: size.width / 2) as CGFloat,
                    y: rand(min: -size.height / 2, max: size.height / 2) as CGFloat
                )
            )
            let wanderingComponent = WanderingComponent()
            wanderingComponent.wanderingRadius = 50
            wanderingComponent.centeredAround = enemyNode.position
            wanderingComponent.maxSpeed = 10
            enemyNode.addComponent(wanderingComponent)
            self << enemyNode
        }

        timeline.every(5...7, startAt: 1) {
            let startAngle: CGFloat = rand(TAU)
            let flyAngle: CGFloat = startAngle + TAU_2 ± rand(TAU_16)
            let velocity = CGPoint(r: 100, a: flyAngle)

            let dist: CGFloat = 12
            let center = self.outsideWorld(extra: dist * 2 + 1, angle: startAngle)
            let left = CGVector(r: dist, a: flyAngle + TAU_4)
            let right = CGVector(r: dist, a: flyAngle - TAU_4)
            let back = CGVector(r: dist * 2, a: flyAngle)

            let origins: [CGPoint] = [
                center,
                center + left,
                center + right,
                center + back,
                center + back + left,
                center + back + right,
                center - back,
                center - back + left,
                center - back + right,
            ]
            for origin in origins {
                let enemy = EnemyJetNode(at: origin)
                enemy.name = "jet"
                enemy.rotateTo(flyAngle)
                self << enemy

                enemy.flyingComponent!.maxSpeed = velocity.length
                enemy.flyingComponent!.maxTurningSpeed = velocity.length
                enemy.flyingComponent!.currentSpeed = velocity.length
                enemy.flyingComponent!.flyingTargets = [
                    center + CGVector(r: self.outerRadius / 2, a: flyAngle) + CGVector(r: ±rand(25), a: flyAngle + TAU_4),
                    center + CGVector(r: self.outerRadius, a: flyAngle) + CGVector(r: ±rand(25), a: flyAngle + TAU_4),
                    center + CGVector(r: self.outerRadius * 2, a: flyAngle) + CGVector(r: ±rand(25), a: flyAngle + TAU_4),
                ]

                self.timeline.after(7) {
                    enemy.removeFromParent()
                }
            }
        }

        let startButtonNode = Button(at: CGPoint(x: 0, y: 0))
        startButtonNode.text = "START"
        startButtonNode.onTapped {
            self.director?.presentWorld(BaseLevel1().tutorialOrLevel())
        }
        self << startButtonNode

        let setupButtonNode = Button(at: CGPoint(x: 0, y: -60))
        setupButtonNode.text = "SETUP"
        setupButtonNode.onTapped {
            self.director?.presentWorld(StartupWorld())
        }
        self << setupButtonNode
    }

    override func worldTouchEnded(worldLocation: CGPoint) {
        super.worldTouchEnded(worldLocation)
        if timeRate < 1 {
            worldShook()
        }
        else {
            cameraNode = Node(at: worldLocation * 3)
            setScale(3)
            timeRate = 0.1
        }
    }

    override func worldShook() {
        cameraNode = Node(at: CGPointZero)
        setScale(1)
        timeRate = 1
    }

}
