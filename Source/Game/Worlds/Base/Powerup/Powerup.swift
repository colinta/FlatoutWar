//
//  Powerup.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

private let PowerupYOffset: CGFloat = 40

class Powerup {
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

    var timeout: CGFloat = 5
    var cooldown: CGFloat = 0
    var name: String { return "" }
    var powerupType: ImageIdentifier.PowerupType? { return .None }

    var count: Int? = 0
    var powerupButton: Button?
    var powerupCount: TextNode?
    var powerupCountdown: SKSpriteNode?
    var powerupEnabled = true

    weak var level: World?
    weak var playerNode: Node?

    func buttonIcon() -> (Button, SKNode) {
        let button = Button()
        button.text = name
        button.alignment = .Left

        let icon = self.icon()
        icon.position = CGPoint(x: -icon.size.width / 2 - 4)
        button.margins.left = icon.size.width
        button << icon

        return (button, icon)
    }

    func icon() -> SKSpriteNode {
        if let powerupType = powerupType {
            return SKSpriteNode(id: .Powerup(type: powerupType))
        }
        return SKSpriteNode(id: .None)
    }

    func addToLevel(level: World, playerNode: Node, start: CGPoint, dest: Position) {
        self.level = level
        self.playerNode = playerNode

        let countNode = TextNode()
        countNode.font = .Tiny
        countNode.position = CGPoint(20, -20)
        powerupCount = countNode

        if let count = count {
            countNode.text = "\(count)"
        }
        else {
            countNode.text = "∞"
            self.powerupCountdown = nil
        }

        let powerupCountdown = SKSpriteNode(id: .PowerupTimer(percent: 100))
        self.powerupCountdown = powerupCountdown
        powerupCountdown.alpha = 0
        powerupCountdown.zPosition = Z.Bottom.rawValue

        let button = Button(at: start)
        button << powerupCountdown
        button << icon()
        level.gameUI << button
        button << countNode
        button.onTapped(self.activateIfEnabled)
        button.moveTo(dest, duration: 1)
        powerupButton = button
    }

    func activateIfEnabled() {
        guard powerupEnabled else { return }
        guard (count ?? 1) > 0 else { return }

        if let button = powerupButton, level = level, playerNode = playerNode {
            button.enabled = false
            if let prevCount = count {
                let newCount = prevCount - 1
                count = newCount
                powerupCount?.text = "\(newCount)"
            }
            activate(level, playerNode: playerNode) {
                if (self.count ?? 1) > 0 {
                    self.cooldown = self.timeout
                }
            }
        }
    }

    func update(dt: CGFloat) {
        if cooldown > 0 {
            cooldown -= dt
            powerupCountdown?.alpha = 1
            powerupCountdown?.textureId(.PowerupTimer(percent: Int(100 * cooldown / timeout)))

            if cooldown <= 0 {
                powerupCountdown?.alpha = 0
                powerupButton?.enabled = (count ?? 1) > 0
            }
        }
    }

    func activate(level: World, playerNode: Node, completion: Block = {}) {
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
