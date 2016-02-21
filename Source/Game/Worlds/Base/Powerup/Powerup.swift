//
//  Powerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let PowerupYOffset: CGFloat = 40

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
    var count: Int { return 1 }
    var powerupType: ImageIdentifier.PowerupType? { return .None }

    var powerupButtons: [Button] = []
    var powerupEnabled = true

    weak var level: BaseLevel?
    weak var playerNode: Node? { return level?.playerNode }

    static func generateButton(name: String, icon: SKSpriteNode) -> (Button, SKNode) {
        let button = Button()
        button.text = name
        button.alignment = .Left

        icon.position = CGPoint(x: -icon.size.width / 2 - 4)
        button.margins.left = icon.size.width
        button << icon

        return (button, icon)
    }

    func button() -> (Button, SKNode) {
        return Powerup.generateButton(name, icon: buttonIcon())
    }

    func buttonIcon() -> SKSpriteNode {
        if let powerupType = powerupType {
            return SKSpriteNode(id: .Powerup(type: powerupType))
        }
        return SKSpriteNode(id: .None)
    }

    func addToLevel(level: BaseLevel, start: CGPoint, dest: Position) {
        self.level = level

        var alpha: CGFloat = 1
        var offset: CGFloat = 0
        var enabled = true
        count.times {
            let button = Button(at: start)
            button.alpha = alpha
            button.enabled = enabled
            button << buttonIcon()
            level.ui << button
            button.onTapped(.Disable).onTapped(self.checkPowerupAvailability)
            powerupButtons << button

            button.moveTo(dest + CGPoint(y: offset), duration: 1)
            enabled = false
            alpha = 0.5
            offset -= PowerupYOffset
        }
    }

    func checkPowerupAvailability() {
        guard powerupEnabled else { return }

        if let button = powerupButtons.first {
            button.fadeTo(0, duration: 1, removeNode: true)
            powerupButtons.removeAtIndex(0)
            activate()
        }
    }

    func activate() {
        var alpha: CGFloat = 1
        var enabled = true
        let duration: CGFloat = 0.3
        for button in powerupButtons {
            let newPosition = button.position + CGPoint(y: PowerupYOffset)
            button.enabled = enabled

            button.moveTo(newPosition, duration: duration)
            button.fadeTo(alpha, duration: duration)
            alpha = 0.5
            enabled = false
        }
    }

    func onNextTap(slowmo slowmo: Bool = false, onTap: (CGPoint) -> Void) {
        if let level = level {
            if slowmo {
                level.timeRate = 0.333
            }

            let tapNode = Node()
            level << tapNode
            powerupEnabled = false

            let prevDefault = level.defaultNode
            level.defaultNode = tapNode

            let touchComponent = TouchableComponent()
            touchComponent.on(.Down) { location in
                if slowmo {
                    level.timeRate = 1.0
                }
                level.defaultNode = prevDefault
                self.powerupEnabled = true

                let position = tapNode.convertPoint(location, toNode: level)
                onTap(position)
                tapNode.removeFromParent()
            }
            tapNode.addComponent(touchComponent)
        }
    }

    func levelCompleted(success success: Bool) {
        powerupEnabled = false
    }

}

extension Powerup: Equatable {}
func ==(lhs: Powerup, rhs: Powerup) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

class MinesPowerup: Powerup {
    override var name: String { return "MINES" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Mines }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class GrenadesPowerup: Powerup {
    override var name: String { return "GRENADES" }
    override var count: Int { return 3 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Grenades }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class ShieldPowerup: Powerup {
    override var name: String { return "SHIELD" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Shield }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class SoldiersPowerup: Powerup {
    override var name: String { return "SOLDIERS" }
    override var count: Int { return 3 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Soldiers }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class HourglassPowerup: Powerup {
    override var name: String { return "HOURGLASS" }
    override var weight: Weight { return .Special }
    override var count: Int { return 2 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Hourglass }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class PulsePowerup: Powerup {
    override var name: String { return "PULSE" }
    override var count: Int { return 3 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Pulse }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class LaserPowerup: Powerup {
    override var name: String { return "LASER" }
    override var weight: Weight { return .Special }
    override var count: Int { return 2 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Laser }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}

class NetPowerup: Powerup {
    override var name: String { return "NET" }
    override var count: Int { return 5 }
    override var powerupType: ImageIdentifier.PowerupType? { return .Net }

    required override init() {
        super.init()
    }

    override func activate() {
        super.activate()
    }

}
