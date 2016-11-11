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

    func spriteId(bulletUpgrade: HasUpgrade, turretUpgrade: HasUpgrade) -> ImageIdentifier {
        return .None
    }

    func radarId(upgrade: HasUpgrade) -> ImageIdentifier {
        return .BaseRadar(upgrade: upgrade)
    }

    func button() -> Button {
        let body = SKSpriteNode(id: .Base(rotateUpgrade: .False, bulletUpgrade: .False, health: 100))
        body.z = .Player

        let turret = SKSpriteNode(id: spriteId(bulletUpgrade: .False, turretUpgrade: .False))
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

    override func spriteId(bulletUpgrade: HasUpgrade, turretUpgrade: HasUpgrade) -> ImageIdentifier {
        return .BaseSingleTurret(bulletUpgrade: bulletUpgrade, turretUpgrade: turretUpgrade)
    }

}


class RapidTurret: Turret {

    override init() {
        super.init()
        autoFireEnabled = false
        rapidFireEnabled = true
    }

    override func spriteId(bulletUpgrade: HasUpgrade, turretUpgrade: HasUpgrade) -> ImageIdentifier {
        return .BaseRapidTurret(bulletUpgrade: bulletUpgrade, turretUpgrade: turretUpgrade)
    }

    override func radarId(upgrade: HasUpgrade) -> ImageIdentifier {
        return .ColorLine(length: upgrade.baseRadarRadius + 25, color: upgrade.baseRadarColor)
    }

}


class DoubleBarrelTurret: Turret {}
class ShotgunTurret: Turret {}
