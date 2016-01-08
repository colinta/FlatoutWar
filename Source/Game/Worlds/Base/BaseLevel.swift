//
//  BaseLevel.swift
//  FlatoutWar
//
//  Created by Colin Gray on 9/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BaseLevel: Level {
    var playerNode: BasePlayerNode! {
        didSet {
            self.updatePlayer(playerNode)
        }
    }
    var shouldReturnToLevelSelect = false

    required init() {
        super.init()

        playerNode = BasePlayerNode()
        updatePlayer(playerNode)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updatePlayer(node: Node) {
        node.healthComponent?.onKilled {
            if self.playerNode == node {
                self.levelCompleted(success: false)
            }
        }
    }

    override func populateWorld() {
        super.populateWorld()
        defaultNode = playerNode
        self << playerNode
    }

    override final func goToNextWorld() {
        if shouldReturnToLevelSelect {
            director?.presentWorld(LevelSelectWorld())
        }
        else {
            goToNextLevel()
        }
    }

}

extension BaseLevel {

    func goToNextLevel() {
        fatalError("goToNextLevel should be overridden")
    }

    override func levelCompleted(var success success: Bool) {
        // sanity check against a kamikaze triggering a "successful" completion
        if let died = playerNode.healthComponent?.died where died {
            success = false
        }

        super.levelCompleted(success: success)


        let finalTimeline = TimelineComponent()
        addComponent(finalTimeline)

        timeRate = 1
        if success {
            let percentNode = PercentBar(at: CGPoint(x: 50, y: 0))
            self << percentNode

            let totalText = TextNode(at: CGPoint(x: 100, y: 4))
            totalText.text = "\(possibleExperience)"
            totalText.font = .Small
            self << totalText

            let currentText = TextNode(at: CGPoint(x: 30, y: -20))
            currentText.text = "0"
            currentText.font = .Small
            self << currentText

            let maxCount = CGFloat(gainedExperience)
            var countEmUp = CGFloat(0)
            var countEmUpIncrement = CGFloat(0.1)
            let countEmUpRate = CGFloat(0.03)
            finalTimeline.every(countEmUpRate, startAt: 2, until: { countEmUp >= maxCount }) {
                countEmUp = min(countEmUp + countEmUpIncrement, maxCount)
                countEmUpIncrement *= 1.05

                percentNode.complete = countEmUp / CGFloat(self.possibleExperience)
                currentText.text = "\(Int(round(countEmUp * 10)) / 10)"
                currentText.position.x = CGFloat(30) + percentNode.complete * percentNode.size.width
            }

            finalTimeline.when({ countEmUp >= maxCount }) {
                currentText.text = "\(self.gainedExperience)"

                self.backButton.visible = true
                self.nextButton.visible = true
            }

            finalTimeline.every(1) {
                let explosion = EnemyExplosionNode(at: CGPoint(x: ±rand(self.size.width / 4), y: ±rand(self.size.height / 4)))
                self << explosion
            }
        }
        else {
            let playerCenter = playerNode.position
            playerNode.removeFromParent()
            let explosion = PlayerExplosionNode(at: playerCenter)
            self << explosion

            quitButton.visible = true
            restartButton.visible = true

            finalTimeline.every(2) {
                let explosion = PlayerExplosionNode(at: playerCenter)
                self << explosion
            }
        }
    }

}

extension BaseLevel {

    func introduceDrone() -> DroneNode {
        let drone = DroneNode()
        drone.draggableComponent?.maintainDistance(100, around: playerNode)
        drone.position = playerNode.position
        drone.alpha = 0
        self << drone

        let fadeIn = FadeToComponent()
        fadeIn.target = 1
        fadeIn.duration = 1.4
        fadeIn.removeComponentOnFade()
        drone.addComponent(fadeIn)

        let moveTo = MoveToComponent()
        moveTo.target = CGPoint(-30, -60)
        moveTo.speed = DroneNode.DefaultSpeed
        moveTo.onArrived {
            drone.droneEnabled(isMoving: false)
        }
        moveTo.removeComponentOnArrived()
        drone.addComponent(moveTo)
        return drone
    }

}

extension BaseLevel {

    func generateEnemy(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
           angle = angle ± rand(spread)
        }

        let enemyNode = EnemySoldierNode()
        enemyNode.position = outsideWorld(enemyNode, angle: angle)
        self << enemyNode
    }

    func generateLeaderEnemy(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let enemyNode = EnemyLeaderNode()
        enemyNode.position = outsideWorld(enemyNode, angle: angle)
        self << enemyNode
    }

    func generateEnemyFormation(angle: CGFloat)() {
        let enemyLeader = EnemyLeaderNode()
        let center = outsideWorld(enemyLeader, angle: angle)
        enemyLeader.position = center
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
            enemy.follow(enemyLeader)
            self << enemy
        }
    }

    func generateDozers(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let enemyCount = 4
        let height = CGFloat((enemyCount * 12) + 2)
        let dozer = EnemyDozerNode()
        dozer.position = outsideWorld(dozer, angle: angle)
        self << dozer

        let min = -height / 2 + 5
        let max = height / 2 - 5
        for i in 0..<enemyCount {
            let r = interpolate(CGFloat(i), from: (0, 3), to: (min, max))
            let location = dozer.position + CGPoint(r: 10, a: angle) + CGPoint(r: r, a: angle + 90.degrees)
            let enemy = EnemySoldierNode(at: location)
            enemy.follow(dozer, scatter: false)
            self << enemy
        }
    }

    func generateScoutEnemies(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        let d = CGFloat(8)
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        for i in 0..<3 {
            let enemyNode = EnemyScoutNode()
            enemyNode.position = outsideWorld(enemyNode, angle: angle) + CGPoint(r: CGFloat(i) * d, a: angle)
            self << enemyNode
        }
    }

    func generateLeaderWithLinearFollowers(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let dist = CGFloat(25)
        let enemyLeader = EnemyLeaderNode()
        let leaderPosition = outsideWorld(enemyLeader, angle: angle)
        enemyLeader.position = leaderPosition
        self << enemyLeader

        for i in 0...4 {
            let location = leaderPosition + CGVector(r: dist * CGFloat(i), a: angle)
            let enemy = EnemySoldierNode(at: location)
            enemy.follow(enemyLeader)
            self << enemy
        }
    }

    func generateLeaderWithCircularFollowers(genAngle: CGFloat, spread: CGFloat = 0.087266561)() {
        var angle = genAngle
        if spread > 0 {
            angle = angle ± rand(spread)
        }
        let dist = CGFloat(30)

        let ghostPosition = outsideWorld(extra: 40, angle: angle)
        let enemyGhost = Node(at: ghostPosition)
        enemyGhost.name = "enemyGhost"
        let enemyComponent = EnemyComponent()
        enemyComponent.targetable = false
        enemyGhost.addComponent(enemyComponent)

        let rammingComponent = RammingComponent()
        rammingComponent.intersectionNode = enemyGhost
        rammingComponent.removeNodeOnRammed()
        enemyGhost.addComponent(rammingComponent)
        rammingComponent.bindTo(enemyComponent: enemyComponent)
        self << enemyGhost

        var enemies: [Node] = []
        let enemyLeader = EnemyLeaderNode()
        enemyLeader.name = "enemyLeader"
        let leaderPosition = ghostPosition + CGPoint(r: dist + enemyLeader.radius, a: angle)
        enemyLeader.position = leaderPosition
        enemyLeader.follow(enemyGhost)
        self << enemyLeader
        enemies << enemyLeader

        let count = 5
        let angleDelta = TAU / CGFloat(count)
        for i in 0..<count {
            let enemyAngle = CGFloat(i) * angleDelta ± rand(angleDelta / 2)
            let vector = CGVector(r: dist, a: enemyAngle)
            let enemy = EnemySoldierNode(at: leaderPosition + vector)
            enemy.follow(enemyGhost)
            self << enemy
            enemies << enemy
            enemy.name = "enemy"
        }

       enemyComponent.onTargetAcquired { target in
           if let target = target {
               for enemy in enemies {
                   enemy.rotateTowards(target)
               }
           }
       }
    }

}
