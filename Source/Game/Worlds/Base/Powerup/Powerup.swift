//
//  Powerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Powerup {
    enum Weight: Float {
        case Common = 10
        case Special = 4
        case Rare = 1
    }

    static let All: [Powerup] = [
        BomberPowerup(),
        CoffeePowerup(),
        DecoyPowerup(),
        GrenadesPowerup(),
        HourglassPowerup(),
        LaserPowerup(),
        MinesPowerup(),
        NetPowerup(),
        PulsePowerup(),
        ShieldPowerup(),
        SoldiersPowerup(),
    ]

    var weight: Weight { return .Common }
    var name: String { return "" }

    func button(at position: Position) -> Button {
        let button = Button(fixed: position)
        button.text = name
        button.alignment = .Left

        let icon = buttonIcon()
        icon.position = CGPoint(x: -icon.size.width / 2 - 4)
        button.margins.left = icon.size.width
        button << icon

        return button
    }

    func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .None)
    }

    func addToLevel(level: Node, start: CGPoint, dest: CGPoint) {
        let button = Button(at: start)
        button << buttonIcon()
        button.moveTo(dest, duration: 1)
        level << button
    }

}

extension Powerup: Equatable {}
func ==(lhs: Powerup, rhs: Powerup) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

class DecoyPowerup: Powerup {
    override var name: String { return "DECOY" }

    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Decoy))
    }

}

class MinesPowerup: Powerup {
    override var name: String { return "MINES" }
    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Mines))
    }

}

class GrenadesPowerup: Powerup {
    override var name: String { return "GRENADES" }
    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Grenades))
    }

}

class BomberPowerup: Powerup {
    override var name: String { return "BOMBER" }
    override var weight: Weight { return .Rare }

    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Bomber))
    }

}

class ShieldPowerup: Powerup {
    override var name: String { return "SHIELD" }
    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Shield))
    }

}

class SoldiersPowerup: Powerup {
    override var name: String { return "SOLDIERS" }
    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Soldiers))
    }

}

class HourglassPowerup: Powerup {
    override var name: String { return "HOURGLASS" }
    override var weight: Weight { return .Special }

    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Hourglass))
    }

}

class PulsePowerup: Powerup {
    override var name: String { return "PULSE" }
    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Pulse))
    }

}

class LaserPowerup: Powerup {
    override var name: String { return "LASER" }
    override var weight: Weight { return .Special }

    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Laser))
    }

}

class NetPowerup: Powerup {
    override var name: String { return "NET" }
    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Net))
    }

}

class CoffeePowerup: Powerup {
    override var name: String { return "COFFEE" }
    override var weight: Weight { return .Rare }

    required override init() {
        super.init()
    }

    override func buttonIcon() -> SKSpriteNode {
        return SKSpriteNode(id: .Powerup(type: .Coffee))
    }

}
