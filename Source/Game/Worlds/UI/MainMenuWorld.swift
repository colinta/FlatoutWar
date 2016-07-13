////
///  MainMenuWorld.swift
//

class MainMenuWorld: World {

    override func populateWorld() {
        let twoDim = TextNode(fixed: .Top(x: 0, y: -20))
        twoDim.setScale(0.75)
        twoDim.text = "2DIM"
        self.ui << twoDim

        let flatoutWar = TextNode(fixed: .Top(x: 0, y: -70))
        flatoutWar.setScale(1.1)
        flatoutWar.text = "FLATOUT WAR"
        flatoutWar.font = .Big
        self.ui << flatoutWar

        let howMany: Int = rand(8...15)
        howMany.times {
            let enemyNode = EnemySoldierNode(
                at: CGPoint(
                    x: rand(min: -size.width / 2, max: size.width / 2),
                    y: rand(min: -size.height / 2, max: size.height / 2)
                )
            )
            let wanderingComponent = WanderingComponent()
            wanderingComponent.wanderingRadius = 50
            wanderingComponent.centeredAround = enemyNode.position
            wanderingComponent.maxSpeed = 10
            enemyNode.addComponent(wanderingComponent)
            self << enemyNode
        }

        timeline.every(5...7, start: .At(1)) {
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
        startButtonNode.font = .Big
        startButtonNode.onTapped {
            self.director?.presentWorld(IntroductionCutSceneWorld())
        }
        self << startButtonNode

        let continueButtonNode = Button(at: CGPoint(x: 0, y: -60))
        continueButtonNode.text = "CONTINUE"
        continueButtonNode.font = .Big
        continueButtonNode.onTapped {
            self.director?.presentWorld(WorldSelectWorld())
        }
        self << continueButtonNode

        let setupButtonNode = Button(at: CGPoint(x: 0, y: -120))
        setupButtonNode.text = "SETUP"
        setupButtonNode.font = .Big
        setupButtonNode.onTapped {
            self.director?.presentWorld(StartupWorld())
        }
        self << setupButtonNode
    }

}
