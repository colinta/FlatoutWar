////
///  Powerup.swift
//

private let PowerupYOffset: CGFloat = 40

class Powerup {
    var timeout: CGFloat = 5
    var cooldown: CGFloat = 0
    var cancellable = true
    var powerupCancel: Block? = nil
    var name: String { return "" }
    var powerupType: ImageIdentifier.PowerupType? { return .none }

    var count: Int = 0
    var powerupButton: Button?
    var powerupCancelButton: Button?
    var powerupCount: TextNode?
    var powerupCountdown: SKSpriteNode?
    var powerupEnabled = true

    weak var level: World?
    weak var playerNode: Node?

    required init(count: Int) {
        self.count = count
    }

    convenience init() {
        self.init(count: 0)
    }

    func clone() -> Powerup {
        return type(of: self).init(count: self.count)
    }

    func buttonIcon() -> (Button, SKNode) {
        let button = Button()
        button.text = name
        button.alignment = .left

        let icon = self.icon()
        icon.position = CGPoint(x: -icon.size.width / 2 - 4)
        button.margins.left = icon.size.width
        button << icon

        return (button, icon)
    }

    func icon() -> SKSpriteNode {
        if let powerupType = powerupType {
            return SKSpriteNode(id: .powerup(type: powerupType))
        }
        return SKSpriteNode(id: .none)
    }

    func powerupCountNode() -> TextNode {
        let powerupCount = TextNode()
        powerupCount.font = .tiny
        powerupCount.position = CGPoint(14, -10)
        powerupCount.text = "\(count)"
        powerupCount.alignment = .left
        return powerupCount
    }

    func addToLevel(_ level: World, playerNode: Node, start: CGPoint, dest: Position) {
        self.level = level
        self.playerNode = playerNode

        let powerupCount = powerupCountNode()
        self.powerupCount = powerupCount

        let powerupCountdown = SKSpriteNode(id: .powerupTimer(percent: 100))
        self.powerupCountdown = powerupCountdown
        powerupCountdown.alpha = 0
        powerupCountdown.z = .bottom

        let button = Button(at: start)
        button << powerupCountdown
        button << icon()
        button << powerupCount
        button.onTapped(self.activateIfEnabled)
        powerupButton = button
        level.gameUI << button
        button.moveTo(dest, duration: 1)

        let cancelButton = Button()
        cancelButton.visible = false
        cancelButton << SKSpriteNode(id: .noPowerup)
        cancelButton.onTapped {
            self.cancelIfRunning()
        }
        powerupCancelButton = cancelButton
    }

    func cancelIfRunning() {
        powerupCancel?()
    }

    private func powerupStart() {
        guard cancellable else { return }
        guard let powerupCancelButton = powerupCancelButton, let powerupButton = powerupButton else { return }
        if let parent = powerupButton.parent, parent != powerupCancelButton.parent {
            powerupCancelButton.removeFromParent(reset: false)
            parent << powerupCancelButton
        }
        powerupCancelButton.position = powerupButton.position
        powerupCancelButton.visible = true
        powerupCancelButton.zPosition = powerupButton.zPosition + 1
        powerupButton.enabled = false
    }
    func powerupRunning() {
        guard cancellable,
            let powerupCancelButton = powerupCancelButton
        else { return }
        powerupCancelButton.visible = false
    }
    func powerupEnd() {
        guard
            cancellable,
            let powerupCancelButton = powerupCancelButton,
            let powerupButton = powerupButton
        else { return }
        powerupCancelButton.visible = false
        powerupButton.enabled = count > 0
    }

    func activateIfEnabled() {
        guard
            powerupEnabled, count > 0,
            let level = level,
            let playerNode = playerNode
        else { return }

        powerupStart()

        activate(level: level, playerNode: playerNode) {
            self.count -= 1
            self.powerupCount?.text = "\(self.count)"

            if self.count > 0 {
                self.cooldown = self.timeout
            }
        }
    }

    func update(_ dt: CGFloat) {
        if cooldown > 0 {
            cooldown -= dt
            powerupCountdown?.alpha = 1
            powerupCountdown?.textureId(.powerupTimer(percent: Int(100 * cooldown / timeout)))

            if cooldown <= 0 {
                powerupCountdown?.alpha = 0
                powerupEnd()
            }
        }
    }

    func activate(level: World, playerNode: Node, completion: @escaping Block = {}) {
        activate(level: level, layer: level, playerNode: playerNode, completion: completion)
    }

    func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
    }

    func slowmo(on onoff: Bool) {
        if onoff {
            level?.timeRate = 0.333
        }
        else {
            level?.timeRate = 1
        }
    }

    func onNextTap(slowmo: Bool = false, onTap: @escaping (CGPoint) -> Void) {
        guard let level = level else { return }

        if slowmo {
            self.slowmo(on: true)
        }

        let tapNode = Node()
        level << tapNode
        powerupEnabled = false

        let prevDefault = level.defaultNode
        level.defaultNode = tapNode

        let restore: (Bool) -> Void = { slowmo in
            if slowmo {
                self.slowmo(on: false)
            }

            level.defaultNode = prevDefault
            self.powerupEnabled = true
            tapNode.removeFromParent()
        }

        let cancelTimeout: Block
        if cancellable {
            let cancel: Block = {
                self.powerupEnd()
                restore(true)
            }
            cancelTimeout = level.timeline.cancellable.after(time: 3 * level.timeRate, block: cancel)
            self.powerupCancel = cancel ++ cancelTimeout
        }
        else {
            cancelTimeout = {}
        }

        let touchComponent = TouchableComponent()
        touchComponent.on(.down) { location in
            self.powerupCancel = nil
            cancelTimeout()

            let node = Node()
            node.position = location
            node << SKSpriteNode(id: .colorCircle(size: CGSize(60), color: WhiteColor))
            node.scaleTo(0, duration: 0.3, removeNode: true)
            level.addChild(node)

            let position = tapNode.convert(location, to: level)
            onTap(position)

            self.powerupRunning()
            restore(slowmo)
        }
        tapNode.addComponent(touchComponent)
    }

    func levelCompleted() {
        powerupCancel?()
        powerupEnabled = false
    }

}

extension Powerup: Equatable {}
func ==(lhs: Powerup, rhs: Powerup) -> Bool {
    if lhs is BomberPowerup && rhs is BomberPowerup {
        return true
    }
    if lhs is CoffeePowerup && rhs is CoffeePowerup {
        return true
    }
    if lhs is GrenadePowerup && rhs is GrenadePowerup {
        return true
    }
    if lhs is HourglassPowerup && rhs is HourglassPowerup {
        return true
    }
    if lhs is LaserPowerup && rhs is LaserPowerup {
        return true
    }
    if lhs is MinesPowerup && rhs is MinesPowerup {
        return true
    }
    if lhs is NetPowerup && rhs is NetPowerup {
        return true
    }
    if lhs is PulsePowerup && rhs is PulsePowerup {
        return true
    }
    if lhs is ShieldPowerup && rhs is ShieldPowerup {
        return true
    }
    if lhs is SoldiersPowerup && rhs is SoldiersPowerup {
        return true
    }
    return false
}
