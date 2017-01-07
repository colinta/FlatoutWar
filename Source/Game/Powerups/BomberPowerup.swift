////
///  BomberPowerup.swift
//

class BomberPowerup: Powerup {
    override var name: String { return "BOMBER" }
    override var powerupType: ImageIdentifier.PowerupType? { return .Bomber }

    required init(count: Int) {
        super.init(count: count)
        self.timeout = 60
    }

    override func activate(level: World, layer: SKNode, playerNode: Node, completion: @escaping Block = {}) {
        super.activate(level: level, layer: layer, playerNode: playerNode)

        let slowmo: CGFloat = 0.333
        level.timeRate = slowmo

        let pathNode = PathDrawingNode()
        layer << pathNode
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
            layer << bomber

            self.powerupRunning()
            restore()
        }
    }

}
