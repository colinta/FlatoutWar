//
//  WorldSelectWorld.swift
//  FlatoutWar
//
//  Created by Colin Gray on 4/16/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class WorldSelectWorld: World {
    var panIn = false
    var worldLocations: [Level: CGPoint]!

    enum Level {
        case Tutorial
        case Base
    }

    override func populateWorld() {
        pauseable = false
        worldLocations = [
            .Tutorial: CGPoint(-200, 0),
            .Base: CGPoint(-200, 100),
        ]

        if panIn {
            let startLeft = -size.width
            self.moveCamera(from: CGPoint(x: startLeft),
                to: CGPoint(x: 0),
                duration: 3)
        }

        self << Line(
            from: CGPoint(x: -size.width / 2),
            to: CGPoint(x: -225)
        )
        self << Line(
            from: CGPoint(x: -200, y: 25),
            to: CGPoint(x: -200, y: 75)
        )

        do {
            let button = generateButton(worldLocations[.Tutorial]!)
            button.onTapped {
                self.director?.presentWorld(BaseLevelSelectWorld())
            }
            button.text = "0"
            self << button
        }

        do {
            let button = generateButton(worldLocations[.Base]!)
            button.enabled = false
            button.onTapped {
            }
            button.text = "1"
            self << button
        }
    }

    func generateButton(position: CGPoint) -> Button {
        let button = Button(at: position)
        button.style = .SquareSized(50)
        button.font = .Big
        return button
    }

}
