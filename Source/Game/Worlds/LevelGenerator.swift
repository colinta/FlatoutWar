////
///  LevelGenerator.swift
//

extension Level {

    func generateWarning(_ screenAngles: CGFloat...) {
        let insetSize = SKSpriteNode(id: .Warning).size + CGSize(10)
        let innerRect = CGRect(centerSize: size - insetSize)
        for screenAngle in screenAngles {
            let warning = Node()
            let sprite = SKSpriteNode(id: .Warning)
            sprite.z = .UITop
            warning << sprite
            warning.position = outsideWorld(extra: 0, angle: screenAngle, ui: true)
                .ensureInside(innerRect)
            warning.addComponent(JiggleComponent(timeout: nil))
            warning.fadeTo(1, start: 0, duration: 1)
            timeline.after(time: 2) {
                warning.fadeTo(0, start: 1, duration: 1)
            }
            gameUI << warning
        }
    }

    func generateEnemy(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemySoldierNode()
            enemyNode.name = "soldier"
            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateFastEnemy(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
               screenAngle = screenAngle ± rand(spread)
            }

            let enemyNode = EnemyFastSoldierNode()
            enemyNode.name = "fast"
            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateSlowEnemy(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyNode = EnemySlowSoldierNode()
            enemyNode.name = "slow"
            enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            self << enemyNode
        }
    }

    func generateLeaderEnemy(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let enemyNode = EnemyLeaderNode()
            enemyNode.name = "leader"

            if constRadius {
                enemyNode.position = CGPoint(r: self.outerRadius, a: screenAngle)
            }
            else {
                enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle)
            }
            self << enemyNode
        }
    }

    func generateScouts(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561, constRadius: Bool = false) -> Block {
        return {
            var screenAngle = genScreenAngle()
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
                    enemyNode.position = self.outsideWorld(node: enemyNode, angle: screenAngle) + dp
                }
                self << enemyNode
            }
        }
    }

    func generateEnemyPair(_ genScreenAngle: @escaping @autoclosure () -> CGFloat,
        enemy enemyGenerator: @escaping @autoclosure () -> EnemySoldierNode) -> Block
    {
        return {
            let screenAngle = genScreenAngle()
            let ghost = self.generateEnemyGhost(mimic: enemyGenerator(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let angle = ghost.position.angle
            let dist: CGFloat = 5.5
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)

            let origins = [
                ghost.position + left,
                ghost.position + right,
            ]
            for origin in origins {
                let enemy = enemyGenerator()
                enemy.position = origin
                enemy.name = "pair soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

    func generateEnemyTrio(_ genScreenAngle: @escaping @autoclosure () -> CGFloat,
        enemy enemyGenerator: @escaping @autoclosure () -> EnemySoldierNode) -> Block
    {
        return {
            let screenAngle = genScreenAngle()
            let ghost = self.generateEnemyGhost(mimic: enemyGenerator(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let angle = ghost.position.angle
            let dist: CGFloat = 5.5
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)
            let back = CGVector(r: dist * 2, a: angle)

            let origins = [
                ghost.position + left,
                ghost.position + right,
                ghost.position + back,
            ]
            for origin in origins {
                let enemy = enemyGenerator()
                enemy.position = origin
                enemy.name = "trio soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

    func generateEnemyQuad(_ genScreenAngle: @escaping @autoclosure () -> CGFloat,
        enemy enemyGenerator: @escaping @autoclosure () -> EnemySoldierNode) -> Block
    {
        return {
            let screenAngle = genScreenAngle()
            let ghost = self.generateEnemyGhost(mimic: enemyGenerator(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(self.playerNode)

            let dist: CGFloat = 5.5
            let angle = ghost.position.angle
            let left = CGVector(r: dist, a: angle + TAU_4)
            let right = CGVector(r: dist, a: angle - TAU_4)
            let back = CGVector(r: dist * 2, a: angle)

            let origins = [
                ghost.position + left,
                ghost.position + right,
                ghost.position + left + back,
                ghost.position + right + back,
            ]
            for origin in origins {
                let enemy = enemyGenerator()
                enemy.position = origin
                enemy.name = "quad soldier"
                enemy.rotateTo(ghost.zRotation)
                enemy.follow(leader: ghost)
                self << enemy
            }
        }
    }

    func generateEnemyColumn(_ genScreenAngle: @escaping @autoclosure () -> CGFloat,
        enemy enemyGenerator: @escaping @autoclosure () -> EnemySoldierNode) -> Block
    {
        return {
            let screenAngle = genScreenAngle()
            let ghost = self.generateEnemyGhost(mimic: enemyGenerator(), angle: screenAngle, extra: 10)
            ghost.name = "pair ghost"
            ghost.rotateTowards(point: .zero)

            let numPairs = 5
            var r: CGFloat = 0
            let dist: CGFloat = 5
            numPairs.times {
                let angle = ghost.position.angle
                let left = CGVector(r: dist, a: angle + TAU_4) + CGVector(r: r, a: angle)
                let right = CGVector(r: dist, a: angle - TAU_4) + CGVector(r: r, a: angle)
                r += 2 * dist

                let origins = [
                    ghost.position + left,
                    ghost.position + right,
                ]
                for origin in origins {
                    let enemy = enemyGenerator()
                    enemy.position = origin
                    enemy.name = "soldier"
                    enemy.rotateTo(ghost.zRotation)
                    enemy.follow(leader: ghost)
                    self << enemy
                }
            }
        }
    }

    func generateJet(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyJetNode()
            jet.name = "jet"
            jet.position = self.outsideWorld(node: jet, angle: genScreenAngle())

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

    func generateBigJet(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyBigJetNode()
            jet.name = "bigjet"
            jet.position = self.outsideWorld(node: jet, angle: genScreenAngle())

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

    func generateBigJetWithFollowers(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            let jet = EnemyBigJetNode()
            jet.name = "bigjet leader"
            jet.position = self.outsideWorld(node: jet, angle: genScreenAngle()) + CGPoint(y: ±rand(spread))
            jet.rotateTowards(point: .zero)
            self << jet

            let count = 8
            let dist: CGFloat = 10
            var prevNode: Node = jet
            count.times { (i: Int) in
                let location = jet.position + CGVector(r: dist * CGFloat(i), a: genScreenAngle())
                let enemy = EnemyJetNode(at: location)
                enemy.name = "bigjet follower"
                enemy.rotateTo(prevNode.zRotation)
                enemy.follow(leader: prevNode, scatter: .None, component: FollowTargetComponent())
                self << enemy
                prevNode = enemy
            }
        }
    }

    func generateLeaderWithLinearFollowers(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }
            let dist: CGFloat = 25
            let enemyLeader = EnemyLeaderNode()
            let leaderPosition = self.outsideWorld(node: enemyLeader, angle: screenAngle)
            enemyLeader.position = leaderPosition
            enemyLeader.rotateTowards(point: .zero)
            enemyLeader.name = "linear leader"
            self << enemyLeader

            for i in 1...5 {
                let location = leaderPosition + CGVector(r: dist * CGFloat(i), a: screenAngle)
                let enemy = EnemySoldierNode(at: location)
                enemy.name = "linear soldier"
                enemy.rotateTo(enemyLeader.zRotation)
                enemy.follow(leader: enemyLeader)
                self << enemy
            }
        }
    }

    func generateLeaderWithCircularFollowers(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0.087266561) -> Block {
        return {
            var screenAngle = genScreenAngle()
            if spread > 0 {
                screenAngle = screenAngle ± rand(spread)
            }

            let dist: CGFloat = 30
            let enemyLeader = EnemyLeaderNode()
            enemyLeader.name = "circular leader"
            let leaderPosition = self.outsideWorld(extra: dist + enemyLeader.radius + 10, angle: screenAngle)
            enemyLeader.position = leaderPosition
            self << enemyLeader

            let count = 8
            let angleDelta = TAU / CGFloat(count)
            for i in 0..<count {
                let enemyAngle = CGFloat(i) * angleDelta ± rand(angleDelta / 4)
                let vector = CGVector(r: dist, a: enemyAngle)
                let enemy = EnemyScoutNode(at: leaderPosition + vector)
                enemy.name = "circular scout"
                enemy.follow(leader: enemyLeader)
                self << enemy
            }
        }
    }
    func generateEnemyGhost(mimic: Node, angle screenAngle: CGFloat, extra: CGFloat = 0) -> Node {
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

extension Level {
    func generateAllSidesWarnings() {
        10.times { (i: Int) in
            generateWarning(TAU * CGFloat(i) / 10)
        }
    }

    func generateBothSidesWarnings() {
        let angles: [CGFloat] = [
            -size.angle * 7 / 8,
            -size.angle / 2,
            0,
            size.angle / 2,
            size.angle * 7 / 8,
        ]
        for angle in angles {
            generateWarning(angle, TAU_2 + angle)
        }
    }
}
