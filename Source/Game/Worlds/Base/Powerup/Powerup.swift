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
        GrenadePowerup(),
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

    weak var level: World?
    weak var playerNode: Node?

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

    func addToLevel(level: World, playerNode: Node, start: CGPoint, dest: Position) {
        self.level = level
        self.playerNode = playerNode

        var alpha: CGFloat = 1
        var offset: CGFloat = 0
        var enabled = true
        count.times {
            let button = Button(at: start)
            button.alpha = alpha
            button.enabled = enabled
            button << buttonIcon()
            level.gameUI << button
            button.onTapped(.Disable).onTapped(self.activateIfEnabled)
            powerupButtons << button

            button.moveTo(dest + CGPoint(y: offset), duration: 1)
            enabled = false
            alpha = 0.5
            offset -= PowerupYOffset
        }
    }

    func activateIfEnabled() {
        guard powerupEnabled else { return }

        if let button = powerupButtons.first, level = level, playerNode = playerNode {
            button.fadeTo(0, duration: 1, removeNode: true)
            powerupButtons.removeAtIndex(0)
            button.enabled = false
            activate(level, playerNode: playerNode) {
                button.enabled = true
            }
        }
    }

    func activate(level: World, playerNode: Node, completion: Block = {}) {
        let duration: CGFloat = 0.3
        var alpha: CGFloat = 1
        var enabled = true
        for button in powerupButtons {
            let newPosition = button.position + CGPoint(y: PowerupYOffset)
            button.enabled = enabled

            button.moveTo(newPosition, duration: duration)
            button.fadeTo(alpha, duration: duration)
            alpha = 0.5
            enabled = false
        }
    }

    func slowmo(onoff: Bool) {
        if onoff {
            level?.timeRate = 0.333
        }
        else {
            level?.timeRate = 1
        }
    }

    func onNextTap(slowmo slowmo: Bool = false, onTap: (CGPoint) -> Void) {
        if let level = level {
            if slowmo {
                self.slowmo(true)
            }

            let tapNode = Node()
            level << tapNode
            powerupEnabled = false

            let prevDefault = level.defaultNode
            level.defaultNode = tapNode

            let touchComponent = TouchableComponent()
            touchComponent.on(.Down) { location in
                if slowmo {
                    self.slowmo(false)
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
