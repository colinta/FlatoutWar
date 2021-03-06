////
///  IntroductionCutSceneWorld.swift
//

class IntroductionCutSceneWorld: World {
    struct Scene {
        let parent = Node()
        let duration: CGFloat
        let pause: CGFloat
        let run: (Node) -> Void
        let text: [String]
        let cleanup: (World) -> Void

        init(duration: CGFloat = 5, pause: CGFloat = 1, run: @escaping (Node) -> Void, text: [String], cleanup: @escaping (World) -> Void = { _ in }) {
            self.duration = duration
            self.pause = pause
            self.run = run
            self.text = text
            self.cleanup = cleanup
        }
    }

    override func populateWorld() {
        let fadeDuration: CGFloat = 1
        let scenes: [Scene] = [
            Scene(
                run: { parent in
                    20.times {
                        let enemy = EnemySoldierNode()
                        enemy.position = CGPoint(
                            x: ±rand(self.size.width / 2),
                            y: self.size.height / 2 ± rand(self.size.height))
                        parent << enemy
                    }
                    10.times {
                        let enemy = EnemyLeaderNode()
                        enemy.position = CGPoint(
                            x: ±rand(self.size.width / 2),
                            y: self.size.height / 2 ± rand(self.size.height))
                        parent << enemy
                    }
                    10.times {
                        let enemy1 = EnemyJetNode()
                        enemy1.position = CGPoint(
                            x: ±rand(self.size.width / 2),
                            y: self.size.height / 2 ± rand(self.size.height))
                        parent << enemy1

                        let enemy2 = EnemyJetNode()
                        enemy2.position = enemy1.position + CGPoint(y: 10)
                        parent << enemy2

                        let enemy3 = EnemyJetNode()
                        enemy3.position = enemy1.position + CGPoint(y: 20)
                        parent << enemy3
                    }
                    var giantX: CGFloat = -200
                    3.times {
                        let enemy = EnemyGiantNode()
                        enemy.position = CGPoint(
                            x: giantX ± rand(20),
                            y: self.size.height / 2 + enemy.size.height)
                        parent << enemy
                        giantX += 200
                    }
                    10.times {
                        let player = Node()
                        let sprite = SKSpriteNode(id: .warning)
                        player << sprite
                        player.position = CGPoint(y: -100) + self.outsideWorld(node: player, angle: self.randSideAngle(.bottom))
                        let component = PlayerComponent()
                        component.intersectionNode = sprite
                        player.addComponent(component)
                        parent << player
                    }
                },
                text: [
                    "IT WAS AN", "ONSLAUGHT",
                ]
            ),
            Scene(
                run: { parent in
                    10.times {
                        let enemy = EnemySoldierNode()
                        enemy.position = CGPoint(
                            x: ±rand(self.size.width / 2),
                            y: ±rand(self.size.height / 2))
                        parent << enemy
                    }
                    5.times {
                        let enemy = EnemyLeaderNode()
                        enemy.position = CGPoint(
                            x: ±rand(self.size.width / 2),
                            y: ±rand(self.size.height / 2))
                        parent << enemy
                    }
                    15.times {
                        let enemy = EnemyJetNode()
                        enemy.position = CGPoint(
                            x: ±rand(self.size.width / 2),
                            y: ±rand(self.size.height / 2))
                        parent << enemy
                    }
                    let playerPositions = [
                        CGPoint(100, 100),
                        CGPoint(0, -150),
                        CGPoint(-75, -50),
                    ]
                    3.times { (i: Int) in
                        let player = BasePlayerNode()
                        player.lightNode.removeFromParent()
                        player.radarSprite.removeFromParent()
                        player.setRotation(rand(TAU))
                        player.position = playerPositions[i]
                        parent << player
                    }
                },
                text: [
                    "QUADS HAVE TAKEN",
                    "OVER 2DIM",
                ]
            ),
            Scene(
                run: { parent in
                    let player = BasePlayerNode()
                    player.radarSprite.textureId(.baseRadar(upgrade: .false, isSelected: true), scale: .zoomed)
                    player.baseSprite.textureId(.base(movementUpgrade: .false, bulletUpgrade: .false, radarUpgrade: .false, health: 100), scale: .zoomed)
                    player.turretSprite.textureId(.baseSingleTurret(bulletUpgrade: .false), scale: .zoomed)
                    player.position = CGPoint(x: -200)
                    player.scaleTo(1, start: 4, duration: 3)
                    player.fadeTo(1, start: 0, duration: 2).onFaded {
                        player.radarSprite.textureId(.baseRadar(upgrade: .false, isSelected: true))
                        player.baseSprite.textureId(.base(movementUpgrade: .false, bulletUpgrade: .false, radarUpgrade: .false, health: 100))
                        player.turretSprite.textureId(.baseSingleTurret(bulletUpgrade: .false))
                    }
                    parent << player
                },
                text: [
                    "YOU ARE THE",
                    "LAST ICOSAGON",
                ]
            ),
            Scene(
                run: { parent in
                    let player = BasePlayerNode()
                    player.position = CGPoint(x: -200, y: -50)
                    player.setRotation(TAU_8)
                    parent << player

                    8.times { (i: Int) in
                        let position: CGPoint = player.position +
                            CGPoint(r: 200 + CGFloat(i) * 20, a: TAU_8) +
                            CGPoint(r: ±rand(30), a: TAU_3_8)
                        let enemy = EnemySoldierNode(at: position)
                        enemy.scaleTo(1, start: 0, duration: 0.1)
                        parent << enemy
                    }
                },
                text: [
                    "YOU MUST",
                    "SURVIVE",
                ],
                cleanup: { world in
                    world.timeline.after(time: fadeDuration - 0.1) {
                        for enemy in world.enemies {
                            enemy.scaleTo(0, duration: 0.1)
                        }
                    }
                }
            ),
            Scene(
                run: { parent in
                    let player = BasePlayerNode()
                    player.position = CGPoint(x: 180)
                    player.setRotation(-TAU_8)
                    parent << player
                    player.rotateToComponent?.target = TAU_2

                    let drone1 = DroneNode(at: player.position + CGPoint(r: 100, a: TAU_2 - TAU_16))
                    drone1.movementUpgrade = .true
                    drone1.radarUpgrade = .true
                    parent << drone1

                    let cannon = CannonNode(at: player.position + CGPoint(x: -150, y: -80))
                    cannon.setRotation(150.degrees)
                    parent << cannon

                    self.timeline.after(time: 0.5) {
                        let drone2 = DroneNode(at: player.position)
                        drone2.moveTo(player.position + CGPoint(r: 100, a: TAU_2 + 8.degrees), duration: 3)
                        drone2.fadeTo(1, start: 0, duration: 1)
                        parent << drone2
                    }

                    8.times { (i: Int) in
                        let x0: CGFloat = -70
                        let position: CGPoint =
                            CGPoint(x: x0 - CGFloat(i) * 30) +
                            CGPoint(r: ±rand(30), a: TAU_4)
                        let enemy1 = EnemySoldierNode(at: position)
                        enemy1.scaleTo(1, start: 0, duration: 0.1)
                        parent << enemy1
                        let enemy2 = EnemySoldierNode(at: position +
                            CGPoint(x: ±rand(10), y: 25 ± rand(10)))
                        enemy2.scaleTo(1, start: 0, duration: 0.1)
                        parent << enemy2
                    }
                },
                text: [
                    "BUILD YOUR ARMY",
                ],
                cleanup: { world in
                    world.timeline.after(time: fadeDuration - 0.1) {
                        for enemy in world.enemies {
                            enemy.scaleTo(0, duration: 0.1)
                        }
                    }
                }
            ),
            Scene(
                run: { parent in
                },
                text: [
                    "AND PROTECT",
                    "2DIM!",
                ]
            ),
        ]

        var sceneIndex = scenes.startIndex
        var prevScene: Scene?
        var time: CGFloat = 1
        let dy: CGFloat = SmallFont.lineHeight
        while scenes.indices.contains(sceneIndex) {
            let scene = scenes[sceneIndex]
            timeline.at(.at(time)) {
                let delay: CGFloat
                if let prevScene = prevScene {
                    prevScene.cleanup(self)
                    prevScene.parent.fadeTo(0, duration: fadeDuration, removeNode: true)
                    delay = fadeDuration + prevScene.pause
                }
                else {
                    delay = 0
                }

                self.timeline.after(time: delay) {
                    let parent = scene.parent
                    scene.run(parent)
                    let text = scene.text
                    var y: CGFloat = CGFloat(text.count) * dy / 2
                    for line in text {
                        let textNode = TextNode(at: CGPoint(y: y))
                        textNode.text = line
                        parent << textNode
                        y -= dy
                    }
                    parent.fadeTo(1, start: 0, duration: fadeDuration)
                    self << parent
                    prevScene = scene
                }
            }
            sceneIndex = scenes.index(after: sceneIndex)
            time += scene.duration + scene.pause
        }

        timeline.at(.at(time)) {
            prevScene!.parent.fadeTo(0, duration: fadeDuration).onFaded {
                let world = WorldSelectWorld(beginAt: .panIn)
                self.director?.presentWorld(world)
            }
        }
    }

}
