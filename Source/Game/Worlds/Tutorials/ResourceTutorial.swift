////
///  ResourceTutorial.swift
//

class ResourceTutorial: Tutorial, ResourceWorld {
    let resourcePercent = ResourcePercent(max: 10)

    var firstResource = ResourceNode()
    var secondResource = ResourceNode()
    var targetResource: ResourceNode?

    var resourceFound: ((ResourceNode) -> Void)!
    let dragIndicator: Node = createDragIndicator()

    var after2: Block!

    override func populateWorld() {
        super.populateWorld()

        after2 = after(2, self.done)

        ui << resourcePercent

        dragIndicator.alpha = 0
        self << dragIndicator
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
        targetResource = firstResource

        let resourceButton = Button()
        resourceButton.size = CGSize(60)
        resourceButton.touchableComponent?.on(.DragBegan) { location in
            self.playerNode.onDragResourceBegan(at: .zero)
        }
        resourceButton.touchableComponent?.on(.DragMoved) { location in
            self.playerNode.onDraggedResource(from: .zero, to: location)
        }
        resourceButton.touchableComponent?.on(.DragEnded) { location in
            self.playerNode.onDragResourceEnded(at: location)
        }
        self << resourceButton

        timeline.after(time: 1) {
            self.showFirstDrag()
        }
    }

    func showFirstDrag() {
        dragIndicator.position = playerNode.position
        dragIndicator.fadeTo(1, start: 0, duration: 0.3)
        dragIndicator.moveTo(firstResource.position, speed: 100, removeComponent: false).onArrived {
            self.dragIndicator.position = self.playerNode.position
        }

        resourceFound = { _ in
            self.dragIndicator.moveToComponent?.removeFromNode()
            self.dragIndicator.fadeTo(0, rate: 3.333).onFaded {
                self.showSecondDrag()
            }
            self.showSecondResource()
        }
    }

    func showSecondDrag() {
        dragIndicator.position = playerNode.position
        dragIndicator.fadeTo(1, start: 0, duration: 0.3)
        dragIndicator.moveTo(secondResource.position, speed: 100, removeComponent: false).onArrived {
            self.dragIndicator.position = self.playerNode.position
        }

        resourceFound = { _ in
            self.showWhy([
                "THE FURTHER THE RESOURCE IS",
                "THE LESS YOU WILL COLLECT",
            ])

            self.dragIndicator.fadeTo(0, rate: 3.333)
        }
    }
    func showSecondResource() {
        tutorialTextNode.text = "NICE!"
        closeButton.visible = true

        secondResource.position = CGPoint(x: -100, y: 100)
        secondResource.moveTo(CGPoint(x: -100, y: -100), duration: 5)
        self << secondResource
        targetResource = secondResource
    }

    func playerFoundResource(node resourceNode: ResourceNode) {
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

    override func update(_ dt: CGFloat) {
        if let target = targetResource?.position {
            dragIndicator.moveToComponent?.target = target
        }
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}

private func createDragIndicator() -> Node {
    let n = Node()
    let label = TextNode()
    label.text = "DRAG"
    label.setScale(0.8)
    n << label
    n << SKSpriteNode(id: .ColorCircle(size: CGSize(60), color: WhiteColor))
    return n
}
