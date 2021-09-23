////
///  WorldScene.swift
//

private var CalculatedWorldScale: CGFloat?
private var DesiredSize = CGSize(width: 667, height: 375)

class WorldScene: SKScene {
    var world: World
    private var worldScalingNode = SKNode()
    private var effectNode = SKEffectNode()
    private var pauseNode: SKNode?
    var uiNode: Node
    var gameUINode: Node
    var prevTime: TimeInterval?
    var touchSessions: [UITouch: TouchSession] = [:]

    static var worldScale: CGFloat {
        if let scale = CalculatedWorldScale {
            return scale
        }
        let screenSize = UIScreen.main.bounds
        let scale = CGPoint(x: screenSize.width / DesiredSize.width, y: screenSize.height / DesiredSize.height)
        let worldScale = max(min(scale.x, scale.y), 1)
        CalculatedWorldScale = worldScale
        return worldScale
    }

    required init(size: CGSize, world: World) {
        self.world = world
        world.size = size / WorldScene.worldScale
        world.screenSize = size
        uiNode = world.ui
        gameUINode = world.gameUI
        super.init(size: size)
        anchorPoint = CGPoint(0.5, 0.5)

        uiNode.setScale(WorldScene.worldScale)
        gameUINode.setScale(WorldScene.worldScale)
        worldScalingNode.setScale(WorldScene.worldScale)
        worldScalingNode << world
        self << worldScalingNode

        effectNode.shouldEnableEffects = true
        // let blur = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius": 10])
        let blur = CIFilter(name: "CIColorMonochrome", parameters: [
            "inputIntensity": 0.5,
            "inputColor": CIColor(color: .black)
        ])
        effectNode.filter = blur

        self << gameUINode
        self << uiNode
    }

    func worldPaused() {
        if let view = view {
            if let texture = view.texture(from: self) {
                effectNode.removeAllChildren()
                let sprite = SKSpriteNode(texture: texture)
                effectNode << sprite
                if let texture = view.texture(from: effectNode) {
                    pauseNode = SKSpriteNode(texture: texture)
                    self << pauseNode!
                    world.isHidden = true
                    gameUINode.isHidden = true
                }
            }
        }
    }

    func worldUnpaused() {
        world.isHidden = false
        gameUINode.isHidden = false

        if let pauseNode = pauseNode {
            pauseNode.removeFromParent()
        }
        effectNode.removeAllChildren()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(_ currentTime: TimeInterval) {
        if let prevTime = prevTime {
            let dt = CGFloat(currentTime - prevTime)
            world.updateWorld(dt)
        }
        prevTime = currentTime
    }

    func gameShook() {
        world.worldShook()
    }

    override func touchesBegan(_ touchesSet: Set<UITouch>, with event: UIEvent?) {
        for touch in touchesSet {
            let worldLocation = touch.location(in: world)
            let touchSession = TouchSession(
                touch: touch,
                location: worldLocation
            )
            self.touchSessions[touch] = touchSession

            world.worldTouchBegan(touch, worldLocation: touchSession.startingLocation)
        }
    }

    override func touchesMoved(_ touchesSet: Set<UITouch>, with event: UIEvent?) {
        for touch in touchesSet {
            if let touchSession = touchSessions[touch] {
                let worldLocation = touchSession.touch.location(in: world)
                touchSession.currentLocation = worldLocation

                if touchSession.dragging {
                    world.worldDraggingMoved(touch, worldLocation: touchSession.currentLocation)
                }
                else if touchSession.startedDragging {
                    world.worldDraggingBegan(touch, worldLocation: touchSession.startingLocation)

                    touchSession.dragging = true
                    world.worldDraggingMoved(touch, worldLocation: touchSession.currentLocation)
                }
            }
        }
    }

    override func touchesEnded(_ touchesSet: Set<UITouch>, with event: UIEvent?) {
        for touch in touchesSet {
            if let touchSession = touchSessions[touch] {
                if touchSession.dragging {
                    world.worldDraggingEnded(touch, worldLocation: touchSession.currentLocation)
                }
                else {
                    if touchSession.isTap {
                        world.worldTapped(touch, worldLocation: touchSession.currentLocation)
                    }
                    world.worldPressed(touch, worldLocation: touchSession.currentLocation)
                }

                world.worldTouchEnded(touch, worldLocation: touchSession.currentLocation)
            }

            touchSessions[touch] = nil
        }
    }

    override func touchesCancelled(_ touchesSet: Set<UITouch>?, with event: UIEvent?) {
        guard let touchesSet = touchesSet else { return }
        for touch in touchesSet {
            if let touchSession = touchSessions[touch] {
                if touchSession.dragging {
                    world.worldDraggingEnded(touch, worldLocation: touchSession.currentLocation)
                }

                world.worldTouchEnded(touch, worldLocation: touchSession.currentLocation)
            }

            touchSessions[touch] = nil
        }
    }

}
