//
//  BaseUpgradeWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let BigOffset = CGPoint(x: 400, y: 0)

class BaseUpgradeWorld: World {
    var nextWorld: BaseLevel!
    let playerNode = BasePlayerNode()
    let upgradeTextNode = TextNode()
    let buildTextNode = TextNode()

    var storedNodes: [(Node, CGPoint)] = []
    var buildNodes: [(Node, CGPoint)] = []
    var upgradeNodes: [(Node, CGPoint)] = []

    override func populateWorld() {
        super.populateWorld()

        setScale(1)

        let locations = [
            CGPoint(-200, 80),
            CGPoint(-200, 30),
            CGPoint(-200, -20),
            CGPoint(-200, -70),
            CGPoint(-200, -120),

            CGPoint(-150, 80),
            CGPoint(-150, 30),
            CGPoint(-150, -20),
            CGPoint(-150, -70),
            CGPoint(-150, -120),

            CGPoint(-100, 80),
            CGPoint(-100, 30),
            CGPoint(-100, -20),
            CGPoint(-100, -70),
            CGPoint(-100, -120),

            CGPoint(-50, 80),
            CGPoint(-50, 30),
            CGPoint(-50, -20),
            CGPoint(-50, -70),
            CGPoint(-50, -120),
        ]
        var locationIndex = 0
        let nodes = [playerNode] + nextWorld.config.storedPlayers
        for node in nodes {
            node.position = locations[locationIndex]
            storedNodes << (node, node.position)
            customizeNode(node)
            self << node

            locationIndex += 1
            if locationIndex == locations.count {
                break
            }
        }

        do {
            upgradeTextNode.text = "UPGRADE"
            upgradeTextNode.position = CGPoint(x: -120, y: 140)
            upgradeTextNode.font = .Small
            upgradeTextNode.setScale(1.5)
            self << upgradeTextNode

            let moveTo = MoveToComponent()
            upgradeTextNode.addComponent(moveTo)

            storedNodes << (upgradeTextNode, upgradeTextNode.position)
        }

        do {
            buildTextNode.text = "BUILD"
            buildTextNode.position = CGPoint(x: 120, y: 140)
            buildTextNode.font = .Small
            buildTextNode.setScale(1.5)
            self << buildTextNode

            let moveTo = MoveToComponent()
            moveTo.duration = 0.5
            buildTextNode.addComponent(moveTo)

            buildNodes << (buildTextNode, buildTextNode.position)

            let drone = DroneNode(at: CGPoint(x: 175, y: -20))
            self << drone
            buildNodes << (drone, drone.position)
        }

        let closeButton = CloseButton()
        closeButton.onTapped { _ in
            self.nextWorld.config.storedPlayers = self.storedNodes.map { (node, pt) in return node }
            self.director?.presentWorld(self.nextWorld)
        }
        ui << closeButton
    }

    private func customizeNode(node: Node) {
        if let node = node as? BasePlayerNode {
            node.radar.removeFromParent()
            node.overrideForceFire = false
        }
        else if let node = node as? DroneNode {
            node.wanderingComponent?.enabled = false
            node.radar1.removeFromParent()
            node.radar2.removeFromParent()
            node.phaseComponent?.enabled = false
        }

        let cursor = CursorNode()
        node << cursor

        let selectableComponent = SelectableComponent()
        node.touchableComponent?.removeFromNode()

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Circle)
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected { selected in
            cursor.selected = selected

            let offset: CGPoint
            if selected {
                offset = BigOffset
                self.showUpgradesFor(node)
            }
            else {
                offset = CGPointZero
                for (node, dest) in self.upgradeNodes {
                    node.moveToComponent?.target = dest + BigOffset
                }
                self.upgradeNodes = []
            }

            for (node, dest) in self.buildNodes {
                node.moveToComponent?.target = dest + offset
            }
        }
        node.addComponent(touchableComponent)
        node.addComponent(selectableComponent)
    }

    private func showUpgradesFor(node: Node) {
        var newNodes: [Node] = []

        if node is BasePlayerNode {
            let originalBase = Node()
            originalBase << {
                let node = SKSpriteNode(id: .Base(upgrade: .One, health: 100))
                node.zPosition = Z.Default.rawValue
                return node
            }()
            originalBase << {
                let node = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
                node.zPosition = Z.Above.rawValue
                return node
            }()
            originalBase.position = CGPoint(x: 125, y: 30)

            let arrowBase = TextNode()
            arrowBase.text = "↓"
            arrowBase.font = .Small
            arrowBase.setScale(1.5)
            arrowBase.position = CGPoint(x: 125, y: -20)

            let upgradeBase = Node()
            upgradeBase << {
                let node = SKSpriteNode(id: .Base(upgrade: .Two, health: 100))
                node.zPosition = Z.Default.rawValue
                return node
            }()
            upgradeBase << {
                let node = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
                node.zPosition = Z.Above.rawValue
                return node
            }()
            upgradeBase.position = CGPoint(x: 125, y: -70)

            let originalTurret = Node()
            originalTurret << {
                let node = SKSpriteNode(id: .Base(upgrade: .One, health: 100))
                node.zPosition = Z.Default.rawValue
                return node
            }()
            originalTurret << {
                let node = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
                node.zPosition = Z.Above.rawValue
                return node
            }()
            originalTurret.position = CGPoint(x: 225, y: 30)

            let arrowTurret = TextNode()
            arrowTurret.text = "↓"
            arrowTurret.font = .Small
            arrowTurret.setScale(1.5)
            arrowTurret.position = CGPoint(x: 225, y: -20)

            let upgradeTurret = Node()
            upgradeTurret << {
                let node = SKSpriteNode(id: .Base(upgrade: .One, health: 100))
                node.zPosition = Z.Default.rawValue
                return node
            }()
            upgradeTurret << {
                let node = SKSpriteNode(id: .BaseSingleTurret(upgrade: .Two))
                node.zPosition = Z.Above.rawValue
                return node
            }()
            upgradeTurret.position = CGPoint(x: 225, y: -70)

            newNodes = [originalBase, arrowBase, upgradeBase, originalTurret, arrowTurret, upgradeTurret]
        }
        else if node is DroneNode {
            let originalNode = Node()
            originalNode << SKSpriteNode(id: .Drone(upgrade: .One, health: 100))
            originalNode.position = CGPoint(x: 175, y: 30)

            let arrowNode = TextNode()
            arrowNode.text = "↓"
            arrowNode.font = .Small
            arrowNode.setScale(1.5)
            arrowNode.position = CGPoint(x: 175, y: -20)

            let upgradeNode = Node()
            upgradeNode << SKSpriteNode(id: .Drone(upgrade: .Two, health: 100))
            upgradeNode.position = CGPoint(x: 175, y: -70)

            newNodes = [originalNode, arrowNode, upgradeNode]
        }

        upgradeNodes = []
        for node in newNodes {
            self << node
            upgradeNodes << (node, node.position)

            let moveTo = MoveToComponent()
            moveTo.duration = 0.5
            moveTo.target = node.position
            node.position = node.position + BigOffset
            node.addComponent(moveTo)
        }
    }

}
