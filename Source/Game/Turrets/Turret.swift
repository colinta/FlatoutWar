//
//  Turret.swift
//  FlatoutWar
//
//  Created by Colin Gray on 3/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Turret {
    static let All: [Turret] = [
        SimpleTurret(),
        RapidTurret(),
        DoubleBarrelTurret(),
        ShotgunTurret(),
    ]

    var autoFireEnabled = false
    var rapidFireEnabled = false
    var reallySmart = false

    func spriteId(upgrade upgrade: FiveUpgrades) -> ImageIdentifier {
        return .None
    }

    func radarId(upgrade upgrade: FiveUpgrades) -> ImageIdentifier {
        return .BaseRadar(upgrade: upgrade)
    }

    func button() -> Button {
        let body = SKSpriteNode(id: .Base(upgrade: .One, health: 100))
        body.z = .Player

        let turret = SKSpriteNode(id: spriteId(upgrade: .One))
        turret.z = .AbovePlayer

        let node = Node()
        node << body
        node << turret
        node.position = CGPoint(0)
        node.zRotation = TAU_8
        node.setScale(0.75)

        let button = Button()
        button.style = .SquareSized(40)
        button.size = CGSize(50)
        button << node
        return button
    }

}

class SimpleTurret: Turret {

    override init() {
        super.init()
        autoFireEnabled = true
        rapidFireEnabled = false
    }

    override func spriteId(upgrade upgrade: FiveUpgrades) -> ImageIdentifier {
        return .BaseSingleTurret(upgrade: upgrade)
    }

}


class RapidTurret: Turret {

    override init() {
        super.init()
        autoFireEnabled = false
        rapidFireEnabled = true
    }

    override func spriteId(upgrade upgrade: FiveUpgrades) -> ImageIdentifier {
        return .BaseRapidTurret(upgrade: upgrade)
    }

    override func radarId(upgrade upgrade: FiveUpgrades) -> ImageIdentifier {
        return .ColorLine(length: upgrade.baseRadarRadius + 25, color: upgrade.baseRadarColor)
    }

}


class DoubleBarrelTurret: Turret {}
class ShotgunTurret: Turret {}
