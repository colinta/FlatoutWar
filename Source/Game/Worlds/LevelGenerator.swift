////
///  LevelGenerator.swift
//

extension Level {
    func generateWarning(screenAngles: CGFloat...) {
        let insetSize = SKSpriteNode(id: .Warning).size + CGSize(10)
        let innerRect = CGRect.zero
            .grow(by: size - insetSize)
        for screenAngle in screenAngles {
            let warning = Node()
            let sprite = SKSpriteNode(id: .Warning)
            sprite.z = .UITop
            warning << sprite
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

    func generateResourceArc() -> Block {
        return {
            let resourceAngle: CGFloat = rand(TAU)
            let resourceNode = ResourceNode(goal: 20)
            let p1 = self.outsideWorld(extra: 20, angle: resourceAngle)
            let p2 = self.outsideWorld(extra: 20, angle: resourceAngle + TAU_2)
            let vector = (p2 - p1) / 3
            let arcTo = resourceNode.arcTo(
                p2,
                start: p1,
                speed: 100,
                removeNode: true
                )
            let vectorAngle: CGFloat = ±TAU_4
            arcTo.control = vector + CGPoint(r: vector.length, a: vector.angle + vectorAngle)
            arcTo.control2 = 2 * vector + CGPoint(r: vector.length, a: vector.angle + vectorAngle)
            self << resourceNode
        }
    }

    func generateResourceDrop(side: Side? = nil) -> Block {
        if let side = side {
            return {
                let resourceNode = ResourceNode(goal: 20)

                let midPoint = CGPoint(self.size.width / 4, self.size.height / 4)
                let maxPoint = CGPoint(self.size.width / 2 + resourceNode.size.width, self.size.height / 2 + resourceNode.size.height)

                var startPosition: CGPoint, finalPosition: CGPoint
                switch side {
                    case .Left:
                        startPosition = CGPoint(-midPoint.x, ±maxPoint.y)
                        finalPosition = CGPoint(startPosition.x, -startPosition.y)
                    case .Right:
                        startPosition = CGPoint(midPoint.x, ±maxPoint.y)
                        finalPosition = CGPoint(startPosition.x, -startPosition.y)
                    case .Top:
                        startPosition = CGPoint(±maxPoint.x, midPoint.y)
                        finalPosition = CGPoint(-startPosition.x, startPosition.y)
                    case .Bottom:
                        startPosition = CGPoint(±maxPoint.x, -midPoint.y)
                        finalPosition = CGPoint(-startPosition.x, startPosition.y)
                }

                startPosition += self.cameraNode.position
                finalPosition += self.cameraNode.position
                startPosition / min(self.xScale, 1)
                finalPosition / min(self.xScale, 1)

                resourceNode.position = startPosition
                resourceNode.moveTo(finalPosition, speed: 100, removeNode: true)
                self << resourceNode
            }
        }
        else {
            return generateResourceDrop(Side.rand())
        }
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

            let count = 3
            for i in 0..<count {
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

            let count = 8
            let dist: CGFloat = 10
            var prevNode: Node = jet
            count.times { (i: Int) in
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

    func generateEnemyGhost(mimic mimic: Node, angle screenAngle: CGFloat, extra: CGFloat = 0) -> Node {
        let position = outsideWorld(extra: extra, angle: screenAngle)
        let enemyGhost = Node(at: position)
        let sprite = SKNode.size(mimic.size)
        enemyGhost << sprite
        enemyGhost.name = "ghost"

        let targetingComponent = PlayerTargetingComponent()
        enemyGhost.addComponent(targetingComponent)

        let rammingComponent = PlayerRammingComponent()
        rammingComponent.intersectionNode = sprite
        rammingComponent.onRammed { _ in
            enemyGhost.removeFromParent()
        }

        if let mimicRammingComponent = mimic.rammingComponent {
            rammingComponent.acceleration = mimicRammingComponent.acceleration
            rammingComponent.currentSpeed = mimicRammingComponent.currentSpeed
            rammingComponent.maxSpeed = mimicRammingComponent.maxSpeed
            rammingComponent.maxTurningSpeed = mimicRammingComponent.maxTurningSpeed
        }

        enemyGhost.addComponent(rammingComponent)
        rammingComponent.bindTo(targetingComponent: targetingComponent)
        self << enemyGhost

        return enemyGhost
    }
}
