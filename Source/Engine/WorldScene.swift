//
//  WorldScene.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private var CalculatedWorldScale: CGFloat?
private var DesiredSize = CGSize(width: 568, height: 320)

class WorldScene: SKScene {
    var world: World
    private var worldScalingNode = SKNode()
    private var blurryNode = SKEffectNode()
    private var pauseNode: SKNode?
    var uiNode = Node()
    var prevTime: NSTimeInterval?
    var touchSession: TouchSession?

    static var worldScale: CGFloat {
        if let scale = CalculatedWorldScale {
            return scale
        }
        let screenSize = UIScreen.mainScreen().bounds
        let scale = CGPoint(x: screenSize.width / DesiredSize.width, y: screenSize.height / DesiredSize.height)
        let worldScale = max(min(scale.x, scale.y), 1)
        CalculatedWorldScale = worldScale
        return worldScale
    }

    required init(size: CGSize, world: World) {
        self.world = world
        world.size = size / WorldScene.worldScale
        world.screenSize = size
        super.init(size: size)
        anchorPoint = CGPoint(0.5, 0.5)

        worldScalingNode.setScale(WorldScene.worldScale)
        worldScalingNode << world
        self << worldScalingNode

        blurryNode.shouldEnableEffects = true
        let blur = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius": 10])
        blurryNode.filter = blur

        self << uiNode
    }

    func worldPaused() {
        if let view = view {
            if let texture = view.textureFromNode(self) {
                let sprite = SKSpriteNode(texture: texture)
                blurryNode << sprite
                if let texture = view.textureFromNode(blurryNode) {
                    blurryNode.removeAllChildren()
                    pauseNode = SKSpriteNode(texture: texture)
                    self << pauseNode!
                    world.hidden = true
                }
            }
        }
    }

    func worldUnpaused() {
        world.hidden = false
        if let pauseNode = pauseNode {
            pauseNode.removeFromParent()
        }
        blurryNode.removeAllChildren()
    }

    required init?(coder: NSCoder) {
        world = coder.decode("world")
        uiNode = coder.decode("ui")
        prevTime = NSTimeInterval(coder.decodeFloat("prevTime") ?? 0)
        super.init(coder: coder)
    }

    override func update(currentTime: NSTimeInterval) {
        if let prevTime = prevTime {
            let dt = CGFloat(currentTime - prevTime)
            world.updateWorld(dt)
        }
        prevTime = currentTime
    }

}

extension WorldScene {
    func gameShook() {
        world.worldShook()
    }

    override func touchesBegan(touchesSet: Set<UITouch>, withEvent event: UIEvent?) {
        guard touchSession == nil else {
            return
        }

        if let touch = touchesSet.first {
            let worldLocation = touch.locationInNode(world)
            let touchSession = TouchSession(
                touch: touch,
                location: worldLocation
            )
            self.touchSession = touchSession

            world.worldTouchBegan(touchSession.startingLocation)
        }
    }

    override func touchesMoved(touchesSet: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchSession = touchSession
        where touchesSet.contains(touchSession.touch)
        {
            let worldLocation = touchSession.touch.locationInNode(world)
            touchSession.currentLocation = worldLocation

            if touchSession.dragging {
                world.worldDraggingMoved(touchSession.currentLocation)
            }
            else if touchSession.startedDragging {
                world.worldDraggingBegan(touchSession.startingLocation)

                touchSession.dragging = true
                world.worldDraggingMoved(touchSession.currentLocation)
            }
        }
    }

    override func touchesEnded(touchesSet: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchSession = touchSession
        where touchesSet.contains(touchSession.touch)
        {
            if touchSession.dragging {
                world.worldDraggingEnded(touchSession.currentLocation)
            }
            else {
                if touchSession.isTap {
                    world.worldTapped(touchSession.currentLocation)
                }
                world.worldPressed(touchSession.currentLocation)
            }

            world.worldTouchEnded(touchSession.currentLocation)

            self.touchSession = nil
        }
    }

    override func touchesCancelled(touchesSet: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touchSession = touchSession, touchesSet = touchesSet
        where touchesSet.contains(touchSession.touch)
        {
            if touchSession.dragging {
                world.worldDraggingEnded(touchSession.currentLocation)
            }

            world.worldTouchEnded(touchSession.currentLocation)
        }
        touchSession = nil
    }

}
