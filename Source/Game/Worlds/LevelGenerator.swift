//
//  LevelGenerator.swift
//  FlatoutWar
//
//  Created by Colin Gray on 9/2/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension Level {
    func generateWarning(screenAngles: CGFloat...) {
        let innerRect = CGRect.zero
            .grow(by: size - CGSize(20))
        for screenAngle in screenAngles {
            let warning = Node()
            warning << SKSpriteNode(id: .Warning)
            warning.position = outsideWorld(extra: 0, angle: screenAngle, ui: true)
                .ensureInside(innerRect)
            warning.addComponent(JiggleComponent(timeout: nil))
            warning.fadeTo(1, start: 0, duration: 1)
            timeline.after(2) {
                warning.fadeTo(0, start: 1, duration: 1)
            }
            gameUI << warning
        }
    }

    func generateResource(amount: Int) -> Block {
        return {}
    }

    func generateEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemySoldierNode()
            enemyNode.name = "soldier"
            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateSlowEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyNode = EnemySlowSoldierNode()
            enemyNode.name = "slow"
            enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

    func generateLeaderEnemy(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyNode = EnemyLeaderNode()
            enemyNode.name = "leader"

            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateScouts(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle
            let d: CGFloat = 8
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            for i in 0..<3 {
                let enemyNode = EnemyScoutNode()
                enemyNode.name = "scout"
                let dp = CGPoint(r: CGFloat(i) * d, a: screenAngle)
                if constRadius {
                    enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle) + dp
                }
                else {
                    enemyNode.position = self.outsideWorld(enemyNode, angle: screenAngle) + dp
                }
                self << enemyNode
            }
        }
    }

    func generateJet(genScreenAngle: CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyJetNode()
            jet.name = "jet"
            jet.position = self.outsideWorld(jet, angle: genScreenAngle)

            let angle = normalizeAngle(jet.position.angle)
            let sizeAngle = self.size.angle
            if angle > TAU - sizeAngle || angle <= sizeAngle {
                jet.position.y += ±spread
            }
            else if angle > TAU_2 + sizeAngle {
                jet.position.x += ±spread
            }
            else if angle > TAU_2 - sizeAngle {
                jet.position.y += ±spread
            }
            else {
                jet.position.x += ±spread
            }

            self << jet
        }
    }

    func generateBigJet(genScreenAngle: CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyBigJetNode()
            jet.name = "bigjet"
            jet.position = self.outsideWorld(jet, angle: genScreenAngle)

            let angle = normalizeAngle(jet.position.angle)
            let sizeAngle = self.size.angle
            if angle > TAU - sizeAngle || angle <= sizeAngle {
                jet.position.y += ±spread
            }
            else if angle > TAU_2 + sizeAngle {
                jet.position.x += ±spread
            }
            else if angle > TAU_2 - sizeAngle {
                jet.position.y += ±spread
            }
            else {
                jet.position.x += ±spread
            }

            self << jet
        }
    }

    func generateBigJetWithFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            let jet = EnemyBigJetNode()
            jet.name = "bigjet leader"
            jet.position = self.outsideWorld(jet, angle: genScreenAngle) + CGPoint(y: ±rand(spread))
            jet.rotateTowards(point: .zero)
            self << jet

            let dist: CGFloat = 10
            var prevNode: Node = jet
            for i in 0..<10 {
                let location = jet.position + CGVector(r: dist * CGFloat(i), a: genScreenAngle)
                let enemy = EnemyJetNode(at: location)
                enemy.name = "bigjet follower"
                enemy.rotateTo(prevNode.zRotation)
                enemy.follow(prevNode, scatter: .None, component: FollowTargetComponent())
                self << enemy
                prevNode = enemy
            }
        }
    }

    func generateLeaderWithLinearFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let dist: CGFloat = 25
            let enemyLeader = EnemyLeaderNode()
            let leaderPosition = self.outsideWorld(enemyLeader, angle: screenAngle)
            enemyLeader.position = leaderPosition
            enemyLeader.rotateTowards(point: .zero)
            enemyLeader.name = "linear leader"
            self << enemyLeader

            for i in 1...5 {
                let location = leaderPosition + CGVector(r: dist * CGFloat(i), a: screenAngle)
                let enemy = EnemySoldierNode(at: location)
                enemy.name = "linear soldier"
                enemy.rotateTo(enemyLeader.zRotation)
                enemy.follow(enemyLeader)
                self << enemy
            }
        }
    }

    func generateLeaderWithCircularFollowers(genScreenAngle: CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }

            let ghost = self.generateEnemyGhost(angle: screenAngle, extra: 40)
            ghost.name = "circular ghost"
            ghost.rotateTowards(point: .zero)

            let dist: CGFloat = 30
            var enemies: [Node] = []
            let enemyLeader = EnemyLeaderNode()
            enemyLeader.name = "circular leader"
            let leaderPosition = ghost.position + CGPoint(r: dist + enemyLeader.radius, a: screenAngle)
            enemyLeader.position = leaderPosition
            enemyLeader.rotateTo(ghost.zRotation)
            enemyLeader.follow(ghost)
            self << enemyLeader
            enemies << enemyLeader

            let count = 5
            let angleDelta = TAU / CGFloat(count)
            for i in 0..<count {
                let enemyAngle = CGFloat(i) * angleDelta ± rand(angleDelta / 2)
                let vector = CGVector(r: dist, a: enemyAngle)
                let enemy = EnemySoldierNode(at: leaderPosition + vector)
                enemy.name = "circular soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(ghost)
                self << enemy
                enemies << enemy
            }

           ghost.playerTargetingComponent!.onTargetAcquired { target in
               if let target = target {
                   for enemy in enemies {
                       enemy.rotateTowards(target)
                   }
               }
           }
        }
    }

    func generateEnemyGhost(angle screenAngle: CGFloat, extra: CGFloat = 0) -> Node {
        let position = outsideWorld(extra: extra, angle: screenAngle)
        let enemyGhost = Node(at: position)
        let sprite = SKNode.size(EnemySoldierNode().size)
        enemyGhost << sprite
        enemyGhost.name = "ghost"
        let targetingComponent = PlayerTargetingComponent()
        enemyGhost.addComponent(targetingComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.onRammed { _ in
            enemyGhost.removeFromParent()
        }

        enemyGhost.addComponent(rammingComponent)
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        self << enemyGhost

        return enemyGhost
    }
}
