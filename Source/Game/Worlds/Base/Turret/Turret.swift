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

    func turretId(upgrade: FiveUpgrades) -> ImageIdentifier {
        return .None
    }

    func button() -> (Button, Node) {
        let body = SKSpriteNode(id: .Base(upgrade: .One, health: 100))
        body.zPosition = Z.Player.rawValue

        let turret = SKSpriteNode(id: turretId(.One))
        turret.zPosition = Z.Turret.rawValue

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
        return (button, node)
    }

}

class SimpleTurret: Turret {

    override func turretId(upgrade: FiveUpgrades) -> ImageIdentifier {
        return .BaseSingleTurret(upgrade: upgrade)
    }

}


class RapidTurret: Turret {

    override func turretId(upgrade: FiveUpgrades) -> ImageIdentifier {
        return .BaseRapidTurret(upgrade: upgrade)
    }

}


class DoubleBarrelTurret: Turret {}
class ShotgunTurret: Turret {}
