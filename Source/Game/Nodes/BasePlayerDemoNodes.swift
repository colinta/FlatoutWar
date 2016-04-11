//
//  BasePlayerDemoNodes.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/15/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BasePlayerDemoNode: Node {
    let baseUpgrade: FiveUpgrades
    let radarUpgrade: FiveUpgrades
    let turretUpgrade: FiveUpgrades

    required init(baseUpgrade: FiveUpgrades, radarUpgrade: FiveUpgrades, turretUpgrade: FiveUpgrades) {
        self.baseUpgrade = baseUpgrade
        self.radarUpgrade = radarUpgrade
        self.turretUpgrade = turretUpgrade

        super.init()

        let base = SKSpriteNode(id: .Base(upgrade: baseUpgrade, health: 100))

        let turret = SKSpriteNode(id: .BaseSingleTurret(upgrade: turretUpgrade))
        turret.z = .Above

        self << base
        self << turret
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience required init() {
        self.init(baseUpgrade: .One, radarUpgrade: .One, turretUpgrade: .One)
    }

}

class BasePlayerFiringDemoNode: BasePlayerDemoNode {
    var cooldown: CGFloat = 0

    override func update(dt: CGFloat) {
        guard cooldown <= 0 else {
            cooldown -= dt
            return
        }

        cooldown = turretUpgrade.turretCooldown
        fireBullet(angle: 0)
    }

    private func fireBullet(angle angle: CGFloat) {
        guard let world = world else {
            return
        }

        let velocity: CGFloat = radarUpgrade.radarBulletSpeed
        let style: BulletNode.Style
        if firingComponent?.forceFire ?? false {
            style = .Fast
        }
        else {
            style = .Slow
        }
        let bullet = BulletNode(velocity: CGPoint(r: velocity, a: angle), style: style)
        bullet.position = world.convertPosition(self)

        bullet.size = BaseTurretBulletArtist.bulletSize(.One)
        bullet.zRotation = angle
        bullet.z = Z.Below
        world << bullet
    }

}

class BasePlayerRotatingDemoNode: BasePlayerDemoNode {
    var phase: CGFloat = 0
    var duration: CGFloat = 1

    override func update(dt: CGFloat) {
        phase = (phase + dt / duration) % 1
        self.zRotation = 20.degrees * sin(phase * TAU)
    }

}
