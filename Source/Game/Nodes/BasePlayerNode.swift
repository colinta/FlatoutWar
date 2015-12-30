//
//  BasePlayerNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class BasePlayerNode: Node {
    var radar: SKSpriteNode!
    var base: SKSpriteNode!
    var turret: SKSpriteNode!

    override func reset() {
        super.reset()
    }

    required init() {
        super.init()

        size = CGSize(r: 20)

        let touchableComponent = TouchableComponent()
        touchableComponent.on(.Tapped, onTouchTapped)
        touchableComponent.onDragged(onTouchDragged)
        addComponent(touchableComponent)

        let healthComponent = HealthComponent(health: 100)
        addComponent(healthComponent)

        let playerComponent = PlayerComponent()
        addComponent(playerComponent)

        let rotateToComponent = RotateToComponent()
        rotateToComponent.currentAngle = 0
        addComponent(rotateToComponent)

        let targetingComponent = TargetingComponent()
        targetingComponent.sweepAngle = 30.degrees
        targetingComponent.radius = 300
        addComponent(targetingComponent)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        radar = coder.decode("radar")
        base = coder.decode("base")
        turret = coder.decode("turret")
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func onTouchTapped(location: CGPoint) {
        if !location.lengthWithin(self.radius) {
            startRotatingTo(location.angle)
        }
    }

    func onTouchDragged(prevLocation: CGPoint, location: CGPoint) {
        let angle = prevLocation.angleTo(location, around: position)
        let destAngle = rotateToComponent?.destAngle ?? 0
        startRotatingTo(destAngle + angle)
    }

    private func startRotatingTo(angle: CGFloat) {
        rotateToComponent?.destAngle = angle
    }

    override func populate() {
        radar = SKSpriteNode(id: .Radar(upgrade: .One))
        radar.anchorPoint = CGPoint(0, 0.5)
        radar.zPosition = Node.Z.Bottom.rawValue
        self << radar

        base = SKSpriteNode(id: .Base(upgrade: .One, health: 1))
        base.zPosition = Node.Z.Default.rawValue
        self << base

        turret = SKSpriteNode(id: .BaseSingleTurret(upgrade: .One))
        turret.zPosition = Node.Z.Above.rawValue
        self << turret
    }

    override func update(dt: CGFloat) {
        if let destAngle = rotateToComponent?.destAngle,
            currentAngle = rotateToComponent?.currentAngle
        {
            radar.zRotation = destAngle
            base.zRotation = currentAngle
            turret.zRotation = currentAngle
        }
    }

}
