////
///  ResourceTutorial.swift
//

class ResourceTutorial: Tutorial, ResourceWorld {
    let experiencePercent = ExperiencePercent(goal: 30)
    let resourcePercent = ResourcePercent(max: 10)

    var firstResource = ResourceNode()
    var resourceFound: ((ResourceNode) -> Void)!
    let dragIndicator: Node = {
        let n = Node()
        n << SKSpriteNode(id: .ColorCircle(size: CGSize(60), color: WhiteColor))
        return n
    }()

    var after2: Block!

    override func didAdd(node: Node) {
        super.didAdd(node)
        if let enemyComponent = node.enemyComponent,
            healthComponent = node.healthComponent
        {
            healthComponent.onKilled {
                self.experiencePercent.gain(enemyComponent.experience)
            }
        }
    }

    override func populateWorld() {
        super.populateWorld()

        after2 = after(2, self.done)

        ui << resourcePercent
        ui << experiencePercent

        dragIndicator.alpha = 0
        dragIndicator.position = playerNode.position
        tutorialTextNode.text = "RESOURCES"

        timeline.at(1) {
            self.showWhy([
                "USE RESOURCES FOR POWERUPS",
                "AND TO PURCHASE UPGRADES",
            ])
            self.showFirstResource()
        }
    }

    func showFirstResource() {
        let arcTo = firstResource.arcTo(
            CGPoint(x: 0, y: -100),
            control: CGPoint(x: 200, y: -100),
            start: CGPoint(x: 200, y: 100),
            speed: 50)
        arcTo.rotate = false
        self << firstResource

        let resourceButton = Button()
        resourceButton.size = CGSize(60)
        resourceButton.touchableComponent?.on(.DragBegan) { location in
            self.playerNode.onDragResourceBegan(.zero)
        }
        resourceButton.touchableComponent?.on(.DragMoved) { location in
            self.playerNode.onDraggedResource(prev: .zero, location: location)
        }
        resourceButton.touchableComponent?.on(.DragEnded) { location in
            self.playerNode.onDragResourceEnded(location)
        }
        resourceFound = { resourceNode in
            self.dragIndicator.fadeTo(0, rate: 3.333)
            self.showSecondResource()
        }
        self << resourceButton

        timeline.after(1) {
            self.showFirstDrag()
        }

        timeline.after(3) {
            var distOffset: CGFloat = 0
            30.times { (i: Int) in
                let soldier = EnemySoldierNode()
                soldier.position = CGPoint(r: self.size.width / 2 + distOffset, a: 0)
                self << soldier
                distOffset += soldier.size.width + 4
            }
        }
    }

    func showFirstDrag() {
        dragIndicator.fadeTo(1, start: 0, duration: 0.3)
        dragIndicator.moveTo(firstResource.position, speed: 100, removeComponent: false).onArrived {
            self.dragIndicator.position = self.playerNode.position
        }
        self << dragIndicator
    }

    func showSecondResource() {
        tutorialTextNode.text = "NICE!"
        closeButton.visible = true

        let resourceNode = ResourceNode(at: CGPoint(x: -100, y: 100))
        resourceNode.moveTo(CGPoint(x: -100, y: -100), duration: 5)
        self << resourceNode

        resourceFound = { _ in }
    }

    func playerFoundResource(resourceNode: ResourceNode) {
        resourceNode.locked = true
        resourceNode.disableMovingComponents()

        let resourcePoint = playerNode.convertPosition(resourceNode)
        let resourceLine = SKSpriteNode()
        resourceLine.anchorPoint = CGPoint(0, 0.5)
        resourceLine.z = .BelowPlayer
        resourceLine.position = self.playerNode.position
        resourceLine.textureId(.ResourceLine(length: resourcePoint.length))
        resourceLine.zRotation = resourcePoint.angle
        self << resourceLine

        let resourceCollector = ResourceCollector(resource: resourceNode)
        resourceCollector.resourceLine = resourceLine
        resourceCollector.position = playerNode.position

        resourceCollector.onHarvest { harvested in
            self.resourcePercent.gain(harvested)
            self.after2()
        }
        self << resourceCollector

        resourceFound(resourceNode)
    }

    override func update(dt: CGFloat) {
        dragIndicator.moveToComponent?.target = firstResource.position
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
