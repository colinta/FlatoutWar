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
                enemy.name = "pair of \(enemy.name)"
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
                enemy.name = "trio of \(enemy.name)"
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
                enemy.name = "quad of \(enemy.name)"
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
                    enemy.name = "column of \(enemy.name)"
                    enemy.rotateTo(ghost.zRotation)
                    enemy.follow(leader: ghost)
                    self << enemy
                }
            }
        }
    }

    func generateDozer(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()

            let dozer = EnemyDozerNode()
            dozer.position = self.outsideWorld(node: dozer, angle: screenAngle)
            dozer.rotateTowards(self.playerNode)
            self << dozer
        }
    }

    func generateDoubleDozer(_ genScreenAngle: @escaping @autoclosure () -> CGFloat) -> Block {
        return {
            let screenAngle = genScreenAngle()

            let dozer1 = EnemyDozerNode()
            dozer1.name = "\(dozer1.name) 1"
            dozer1.position = self.outsideWorld(node: dozer1, angle: screenAngle)
            dozer1.rotateTowards(self.playerNode)
            self << dozer1

            let dozer1Radius = dozer1.position.length
            let dozer1Angle = dozer1.position.angle

            let dozer2 = EnemyDozerNode()
            dozer2.name = "\(dozer2.name) 2"
            let dozer2Delta = 2 * dozer2.size.width
            let dozer2Radius = dozer1Radius + dozer2Delta
            dozer2.position = CGPoint(r: dozer2Radius, a: dozer1Angle)
            dozer2.minTargetDist = dozer1.minTargetDist + dozer2Delta
            dozer2.rotateTowards(self.playerNode)
            self << dozer2
        }
    }

    func generateJet(_ genScreenAngle: @escaping @autoclosure () -> CGFloat, spread: CGFloat = 0) -> Block {
        return {
            let jet = EnemyJetNode()
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
            jet.name = "\(jet.name) leader"
            jet.position = self.outsideWorld(node: jet, angle: genScreenAngle()) + CGPoint(y: ±rand(spread))
            jet.rotateTowards(point: .zero)
            self << jet

            let count = 8
            let dist: CGFloat = 10
            var prevNode: Node = jet
            count.times { (i: Int) in
                let location = jet.position + CGVector(r: dist * CGFloat(i), a: genScreenAngle())
                let enemy = EnemyJetNode(at: location)
                enemy.name = "\(enemy.name) follower"
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
            enemyLeader.name = "linear \(enemyLeader.name)"
            self << enemyLeader

            for i in 1...5 {
                let location = leaderPosition + CGVector(r: dist * CGFloat(i), a: screenAngle)
                let enemy = EnemySoldierNode(at: location)
                enemy.name = "linear \(enemy.name)"
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
            enemyLeader.name = "circular \(enemyLeader.name)"
            let leaderPosition = self.outsideWorld(extra: dist + enemyLeader.radius + 10, angle: screenAngle)
            enemyLeader.position = leaderPosition
            self << enemyLeader

            let count = 8
            let angleDelta = TAU / CGFloat(count)
            for i in 0..<count {
                let enemyAngle = CGFloat(i) * angleDelta ± rand(angleDelta / 4)
                let vector = CGVector(r: dist, a: enemyAngle)
                let enemy = EnemyScoutNode(at: leaderPosition + vector)
                enemy.name = "circular \(enemy.name)"
                enemy.follow(leader: enemyLeader)
                self << enemy
            }
        }
    }

    enum TransportSource {
        case All
        case Right
    }

    func generateEnemyTransport(
        _ source: TransportSource = .All,
        payload _payload: [EnemySoldierNode]? = nil
        ) -> Block
    {
        let size = self.size / xScale
        return {
            let transport = EnemyJetTransportNode()

            let payload = _payload ?? [
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
                EnemySoldierNode(),
            ]

            var start: CGPoint, control1: CGPoint, control2: CGPoint, dest: CGPoint

            switch source {
                case .All:
                    let routes: [ (start: CGPoint, control1: CGPoint, control2: CGPoint, dest: CGPoint) ] = [
                        (
                            start:    CGPoint(size.width / 2 + transport.size.width, size.height / 2),
                            control1: CGPoint(-size.width / 2, size.height / 2),
                            control2: CGPoint(-size.width / 2, -size.height / 2),
                            dest:     CGPoint(size.width / 2 + transport.size.width, -size.height / 2)
                        ),
                        (
                            start:    CGPoint(size.width / 2, size.height / 2 + transport.size.height),
                            control1: CGPoint(size.width / 2, -size.height / 2),
                            control2: CGPoint(-size.width / 2, -size.height / 2),
                            dest:     CGPoint(-size.width / 2, size.height / 2 + transport.size.height)
                        ),
                    ]
                    (start, control1, control2, dest) = routes.rand()!
                    if rand() {
                        (start, control1, control2, dest) = (dest, control2, control1, start)
                    }
                    if rand() {
                        start.x = -start.x
                        start.y = -start.y
                        control1.x = -control1.x
                        control1.y = -control1.y
                        control2.x = -control2.x
                        control2.y = -control2.y
                        dest.x = -dest.x
                        dest.y = -dest.y
                    }
                case .Right:
                    start = CGPoint(rand(min: size.width / 4 + 20, max: size.width / 2 - 20), ±(size.height / 2 + 2 * transport.size.height))
                    dest = CGPoint(start.x, -start.y)
                    control1 = (start + dest) / 2 + CGPoint(x: ±rand(50))
                    control2 = control1
            }

            let arcTo = transport.arcTo(dest, start: start, speed: 50)
            arcTo.control = control1
            arcTo.control2 = control2
            arcTo.onArrived {
                transport.fadeTo(0, rate: 1, removeNode: true)
            }

            transport.transportPayload(payload)

            self << transport
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
        generateSideWarnings(side: .Left)
        generateSideWarnings(side: .Right)
    }

    func generateSideWarnings(side: World.Side) {
        let sideAngle: CGFloat
        let angle: CGFloat
        switch side {
        case .Left:
            angle = TAU_2
            sideAngle = size.angle
        case .Right:
            angle = 0
            sideAngle = size.angle
        case .Top:
            angle = TAU_4
            sideAngle = TAU_4 - size.angle
        case .Bottom:
            angle = TAU_3_4
            sideAngle = TAU_4 - size.angle
        }

        let angleDeltas: [CGFloat] = [
            -sideAngle * 7 / 8,
            -sideAngle / 2,
            0,
            sideAngle / 2,
            sideAngle * 7 / 8,
        ]

        for delta in angleDeltas {
            generateWarning(angle + delta)
        }
    }

}
