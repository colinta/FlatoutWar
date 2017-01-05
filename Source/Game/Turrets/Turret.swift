////
///  Turret.swift
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

    required init() {
    }

    func spriteId(bulletUpgrade: HasUpgrade) -> ImageIdentifier {
        return .None
    }

    func radarId(upgrade: HasUpgrade, isSelected: Bool) -> ImageIdentifier {
        return .BaseRadar(upgrade: upgrade, isSelected: isSelected)
    }

    func clone() -> Turret {
        let turret = type(of: self).init()
        return turret
    }

    func button() -> Button {
        let body = SKSpriteNode(id: .Base(movementUpgrade: .False, bulletUpgrade: .False, radarUpgrade: .False, health: 100))
        body.z = .Player

        let turret = SKSpriteNode(id: spriteId(bulletUpgrade: .False))
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

    required init() {
        super.init()
        autoFireEnabled = true
        rapidFireEnabled = false
    }

    override func spriteId(bulletUpgrade: HasUpgrade) -> ImageIdentifier {
        return .BaseSingleTurret(bulletUpgrade: bulletUpgrade)
    }

}


class RapidTurret: Turret {

    required init() {
        super.init()
        autoFireEnabled = false
        rapidFireEnabled = true
    }

    override func spriteId(bulletUpgrade: HasUpgrade) -> ImageIdentifier {
        return .BaseRapidTurret(bulletUpgrade: bulletUpgrade)
    }

    override func radarId(upgrade: HasUpgrade, isSelected: Bool) -> ImageIdentifier {
        return .ColorLine(length: upgrade.baseRadarRadius + 25, color: upgrade.baseRadarColor)
    }

}


class DoubleBarrelTurret: Turret {}
class ShotgunTurret: Turret {}
