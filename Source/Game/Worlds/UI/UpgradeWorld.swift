//
//  UpgradeWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let BigOffset = CGPoint(x: 400, y: 0)

class UpgradeWorld: World {
    var nextWorld: BaseLevel!
    let config = UpgradeConfigSummary()
    var levelConfig: BaseConfig { return nextWorld.config }

    var playerNode: BasePlayerNode!
    let playersOffset = CGPoint(-125, -20)

    let experienceTextNode = TextNode()

    let greenBox = SKSpriteNode()
    let redBox = SKSpriteNode()

    var storedNodes: [(Node, CGPoint)] = []
    var buildNodes: [(Node, CGPoint)] = []
    var upgradeNodes: [(Node, CGPoint)] = []

    override func populateWorld() {
        super.populateWorld()
        fadeTo(1, start: 0, duration: 0.5)

        let boxSize = CGSize(width: size.width / 2, height: size.height)
        greenBox.position = CGPoint(x: -size.width / 4)
        greenBox.textureId(.FillColorBox(size: boxSize, color: 0x149C10))
        redBox.position = CGPoint(x: size.width / 4)
        redBox.textureId(.FillColorBox(size: boxSize, color: 0x8F000A))
        for box in [greenBox, redBox] {
            box.hidden = true
            box.alpha = 0.5
            box.z = .Bottom
            self << box
        }

        setScale(1)

        let nodes = nextWorld.config.storedPlayers
        for node in nodes {
            node.position = node.position + playersOffset
            if let player = node as? BasePlayerNode {
                playerNode = player
            }
        }
        for node in nodes {
            addStoredNode(node)
        }

        experienceTextNode.position = CGPoint(-12, 135)
        experienceTextNode.text = "$\(config.availableExperience)"
        experienceTextNode.textScale = 2
        self << experienceTextNode

        do {
            var buildableNodes: [(Node, Int)] = []
            let drone = DroneNode(at: CGPoint(x: 125, y: -20))

            buildableNodes << (drone, 1000)

            for (node, cost) in buildableNodes{
                customizeBuildNode(node, cost: cost)
                self << node
            }
        }

        let closeButton = Button()
        closeButton.position = CGPoint(0, -135)
        closeButton.text = "DONE"
        closeButton.setScale(1.5)
        closeButton.onTapped { _ in
            self.nextWorld.config.storedPlayers = self.storedNodes.map { (node, pt) in
                node.position = node.position - self.playersOffset
                return node
            }
            self.director?.presentWorld(self.nextWorld)
        }
        self << closeButton
    }

    private func addStoredNode(node: Node) {
        customizeUpgradeNode(node)
        self << node
    }

    private func customizeBuildNode(node: Node, cost: Int) {
        let originalPosition = node.position

        let moveTo1 = MoveToComponent()
        moveTo1.duration = 0.5
        node.addComponent(moveTo1)

        let costTextNode = TextNode(at: node.position + CGPoint(x: node.radius + 3))
        costTextNode.text = cost.description
        costTextNode.alignment = .Left
        self << costTextNode

        let moveTo2 = MoveToComponent()
        moveTo2.duration = 0.5
        costTextNode.addComponent(moveTo2)

        buildNodes << (node, node.position)
        buildNodes << (costTextNode, costTextNode.position)

        node.touchableComponent?.removeFromNode()
        node.draggableComponent?.removeFromNode()
        node.wanderingComponent?.removeFromNode()

        let cursor = CursorNode()
        node << cursor

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Circle)
        touchableComponent.on(.DownInside) { _ in
            let canAfford = self.config.canAfford(cost)
            self.experienceTextNode.color = canAfford ? nil : 0xAE000E
            self.redBox.hidden = canAfford
            self.greenBox.hidden = !canAfford
        }
        touchableComponent.on(.Up) { _ in
            self.redBox.hidden = true
            self.greenBox.hidden = true
            self.experienceTextNode.color = nil
        }
        node.addComponent(touchableComponent)

        let draggableComponent = DraggableComponent()
        draggableComponent.speed = nil
        draggableComponent.shouldAdjustEnabled = false
        draggableComponent.bindTo(touchableComponent: touchableComponent)
        draggableComponent.onDragging { (isDragging, nodeLocation) in
            let location = self.convertPoint(nodeLocation, fromNode: node)
            let canAfford = self.config.canAfford(cost)

            if !isDragging {
                if location.x < 0 && canAfford {
                    let newNode = node.dynamicType.init()
                    newNode.position = location
                    self.addStoredNode(newNode)
                }

                draggableComponent.target = nil
                node.position = originalPosition
            }
        }

        node.addComponent(draggableComponent)
    }

    private func customizeUpgradeNode(node: Node) {
        storedNodes << (node, node.position)

        if let player = node as? BasePlayerNode {
            player.rotateTo(TAU_3_4)
            player.forceFireEnabled = false
        }

        node.touchableComponent?.removeFromNode()
        node.draggableComponent?.removeFromNode()
        node.wanderingComponent?.removeFromNode()

        let cursor = CursorNode()
        node << cursor

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Circle)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { selected in
            cursor.selected = selected

            let offset: CGPoint
            if selected {
                offset = BigOffset
                self.showUpgradesFor(node)
            }
            else {
                offset = .zero
                for (node, dest) in self.upgradeNodes {
                    node.moveToComponent?.target = dest + BigOffset
                }
                self.upgradeNodes = []
            }

            for (node, dest) in self.buildNodes {
                if let moveToComponent = node.moveToComponent {
                    moveToComponent.target = dest + offset
                }
                else {
                    print("you need to add MoveToComponent to \(node)")
                }
            }
        }
        node.addComponent(touchableComponent)
        node.addComponent(selectableComponent)

        if node is DraggableNode {
            let draggableComponent = DraggableComponent()
            draggableComponent.speed = nil
            draggableComponent.bindTo(touchableComponent: touchableComponent)
            draggableComponent.onDragChange { isMoving in
                self.world?.unselectNode(node)
            }
            draggableComponent.maintainDistance(100, around: playerNode)
            node.addComponent(draggableComponent)
        }
    }

    private func showUpgradesFor(node: Node, animated: Bool = true) {
        for (node, _) in upgradeNodes {
            node.removeFromParent()
        }

        var newNodes: [Node] = []

        let leftX: CGFloat = 100
        let upgradeOffset: CGFloat = -37
        let textOffset: CGFloat = 30

        let availableUpgrades = node.availableUpgrades()
        var y: CGFloat = -40 + CGFloat(availableUpgrades.count) * 40
        for (upgradeNode, cost, upgradeType) in availableUpgrades {
            let purchaseButton = Button(at: CGPoint(x: leftX, y: y))
            purchaseButton.style = .RectSized(140, 50)
            let purchaseText = TextNode(at: CGPoint(x: textOffset))
            purchaseText.text = "\(cost)"
            purchaseText.setScale(1.5)
            purchaseButton << purchaseText

            if config.canAfford(cost) {
                purchaseText.color = nil
            }
            else {
                purchaseText.color = 0xC5C5C5
            }

            purchaseButton.onTapped {
                self.spendExperience(cost)
                node.applyUpgrade(upgradeType)
                self.showUpgradesFor(node, animated: false)
            }

            let crop = CropNode()
            crop.maskNode = SKSpriteNode(id: .FillColorBox(size: CGSize(212.5, 50), color: 0xffffff))
            crop << upgradeNode
            crop.position = CGPoint(x: upgradeOffset, y: 0)
            purchaseButton << crop

            newNodes << purchaseButton

            y -= 80
        }

        upgradeNodes = []
        for node in newNodes {
            self << node
            upgradeNodes << (node, node.position)

            let moveTo = MoveToComponent()
            moveTo.duration = 0.5
            moveTo.target = node.position
            if animated {
                node.position = node.position + BigOffset
            }
            node.addComponent(moveTo)
        }
    }

    private func spendExperience(cost: Int) {
        config.spent(cost)
    }

    private var currentDelta = 1

    override func update(dt: CGFloat) {
        super.update(dt)

        let available = config.availableExperience
        if let current = Int(experienceTextNode.text) where current != available {
            let newValue = max(available, current - currentDelta)
            experienceTextNode.text = "\(newValue)"
            currentDelta += 1
        }
        else {
            currentDelta = 1
        }
    }

}
