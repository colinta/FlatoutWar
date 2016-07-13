////
///  BomberPowerup.swift
//

class BomberPowerup: Powerup {
    override var name: String { return "BOMBER" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Bomber }
    override var nextResourceCosts: [Int: Int] { return [
        0: 50,
        1: 100,
    ] }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 60
    }

    override func activate(level: World, playerNode: Node, completion: Block = {}) {
        super.activate(level, playerNode: playerNode)

        let slowmo: CGFloat = 0.333
        level.timeRate = slowmo

        let pathNode = PathDrawingNode()
        playerNode << pathNode
        powerupEnabled = false

        let prevDefault = level.defaultNode
        level.defaultNode = pathNode

        let restore: Block = {
            level.defaultNode = prevDefault
            self.powerupEnabled = true
            pathNode.removeFromParent()
        }
        let cancel: Block = {
            level.timeRate = 1
            self.powerupEnd()
        }
        self.powerupCancel = restore ++ cancel

        let touchComponent = pathNode.touchableComponent!
        touchComponent.on(.Up) { location in
            let bomber = BomberPowerupNode()
            bomber.timeRate = 1 / slowmo
            bomber.scaleTo(1, start: 1.5, duration: 1)
            bomber.fadeTo(1, start: 0, duration: 1)
            bomber.followPathComponent.pathFn = pathNode.pathFn
            bomber.followPathComponent.onArrived {
                bomber.timeRate = 1
                level.timeRate = 1

                bomber.scaleTo(1.5, duration: 1)
                bomber.fadeTo(0, duration: 1, removeNode: true)
                completion()
            }
            playerNode << bomber

            self.powerupRunning()
            restore()
        }
    }

}
