////
///  WorldScene.swift
//

class WorldScene: SKScene {
    var world: World
    private var worldScalingNode = SKNode()
    private var effectNode = SKEffectNode()
    private var pauseNode: SKNode?
    var uiNode: Node
    var gameUINode: Node
    var prevTime: TimeInterval?
    var touchSessions: [UITouch: TouchSession] = [:]

    private(set) var worldScale: CGFloat
    private var lastLayout: ViewportLayout?

    required init(size: CGSize, world: World) {
        let bounds = CGRect(origin: .zero, size: size)
        let layout = ViewportLayout(viewBounds: bounds, safeFrame: bounds)
        self.world = world
        worldScale = layout.worldScale
        world.size = layout.worldSize
        world.screenSize = size
        uiNode = world.ui
        gameUINode = world.gameUI
        super.init(size: size)
        anchorPoint = CGPoint(0.5, 0.5)

        uiNode.setScale(worldScale)
        gameUINode.setScale(worldScale)
        worldScalingNode.setScale(worldScale)
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

    func updateLayout(in view: WorldView) {
        guard view.bounds.width > 0, view.bounds.height > 0 else { return }
        let layout = ViewportLayout(viewBounds: view.bounds, safeFrame: view.safeAreaLayoutGuide.layoutFrame)
        guard layout != lastLayout else { return }
        lastLayout = layout

        size = view.bounds.size
        worldScale = layout.worldScale
        uiNode.setScale(worldScale)
        gameUINode.setScale(worldScale)
        worldScalingNode.setScale(worldScale)
        world.size = layout.worldSize
        world.screenSize = size
        world.uiBounds = layout.uiBounds

        // A paused scene uses a snapshot; it must not retain the old viewport.
        if pauseNode != nil {
            worldUnpaused()
            worldPaused()
        }
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
        // UIKit can deliver bounds and safe-area updates in different passes
        // during a display transition. Recheck cheaply before rendering, too.
        if let view = view as? WorldView {
            updateLayout(in: view)
        }
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
