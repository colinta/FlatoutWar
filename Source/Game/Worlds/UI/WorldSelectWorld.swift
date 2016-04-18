//
//  WorldSelectWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/16/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class WorldSelectWorld: World {
    var worldDistance: CGFloat!
    var worldLocations: [Level: CGFloat]!

    enum Level: Int {
        case Start = 1
        case Tutorial = 2
        case Base = 3
    }

    override func populateWorld() {
        pauseable = false
        worldDistance = 2 * outerRadius + 50
        worldLocations = [
            .Start: 0 * worldDistance,
            .Tutorial: 1 * worldDistance,
            .Base: 2 * worldDistance,
        ]

        self.startAt(.Start)

        do {
            let button = generateButton(x: worldLocations[.Tutorial]!)
            button.onTapped {
                self.moveCamera(to: CGPoint(x: self.worldLocations[.Base]!), duration: 3)
            }
            button.text = "0"
            self << button
        }

        do {
            let button = generateButton(x: worldLocations[.Base]!)
            button.onTapped {
                 self.director?.presentWorld(BaseLevelSelectWorld())
            }
            button.text = "1"
            self << button
        }
    }

    func startAt(start: Level) {
        switch start {
            case .Start: startAtStart()
            case .Tutorial: startAtTutorial()
            case .Base: startAtBase()
        }
    }

    func startAtStart() {
        let startLeft = worldLocations[.Start]!
        self.moveCamera(from: CGPoint(x: startLeft))

        timeline.at(.Delayed()) {
            self.moveCamera(
                to: CGPoint(x: 0),
                duration: 3)
        }

        let minLeft: CGFloat = startLeft - outerRadius
        let maxLeft: CGFloat = -outerRadius - 10
        for _ in 0..<20 {
            let node = Node()
            let sprite = SKSpriteNode(id: .Enemy(type: .Soldier, health: 100))
            let center = CGPoint(
                rand(min: minLeft, max: maxLeft),
                rand(min: -size.height / 2, max: size.height / 2)
            )
            node.position = center
            node << sprite
            node.zRotation = rand(TAU)
            node.addComponent(WanderingComponent(centeredAround: center))
            self << node
        }
    }

    func startAtTutorial() {
        self.moveCamera(from: CGPoint(x: worldLocations[.Tutorial]!))
    }

    func startAtBase() {
        self.moveCamera(from: CGPoint(x: worldLocations[.Base]!))
    }

    func generateButton(x x: CGFloat) -> Button {
        let lineLength = worldDistance - 100
        let position = CGPoint(x: x)
        let button = Button(at: position)
        let line = SKSpriteNode(id: .ColorLine(length: lineLength, color: 0xFFFFFF))

        line.anchorPoint = CGPoint(0, 0.5)
        line.zRotation = TAU_2
        line.position = position + CGPoint(x: -50)
        self << line

        button.touchableComponent?.on(.Enter) { _ in
            line.position = position + CGPoint(x: -55)
        }
        button.touchableComponent?.on(.Exit) { _ in
            line.position = position + CGPoint(x: -50)
        }
        button.style = .SquareSized(100)
        button.font = .Big
        return button
    }

}
