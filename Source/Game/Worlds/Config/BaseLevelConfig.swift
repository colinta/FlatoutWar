////
///  BaseLevelConfig.swift
//

typealias TreeInfo = BaseLevel.TreeInfo

class BaseLevelConfig: LevelConfig {

    override var availablePowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    var treeCenters: [TreeInfo] {
        get {
            var info: [TreeInfo] = []

            do {
                let count = 9
                var y: CGFloat = -1.25
                let dy: CGFloat = -2 * y / CGFloat(count - 1)
                let xs: [CGFloat] = [0.9, 1.05, 1.2, 1.35]
                let centerDelta: CGFloat = 0.05
                info += (0..<count).flatMap { (_: Int) -> [TreeInfo] in
                    let info = xs.map { x -> TreeInfo in
                        let p = CGPoint(x, y) + CGPoint(r: rand(centerDelta), a: rand(TAU))
                        return TreeInfo(center: p)
                    }
                    y += dy
                    return info
                }
            }

            do {
                let centers: [(Int, CGPoint)] = [
                    (3, CGPoint(-1.1, -1)),
                    (2, CGPoint(-1.1, 1)),
                    (1, CGPoint(-0.8, 1.1)),
                    (2, CGPoint(-0.75, -1.05)),
                ]
                let dr: CGFloat = 0.1
                for (count, center) in centers {
                    count.times {
                        let p = (center + CGPoint(r: dr, a: rand(TAU)))
                        info << TreeInfo(center: p)
                    }
                }
            }

            return info
        }
    }
}

class BaseLevelPart1Config: BaseLevelConfig {
    override var availableArmyNodes: [Node] {
        return [DroneNode(at: CGPoint(r: 80, a: rand(TAU)))]
    }
}

class BaseLevelPart2Config: BaseLevelConfig {
    override var availableArmyNodes: [Node] {
        let a1: CGFloat = rand(TAU)
        let a2: CGFloat = a1 + TAU_2 ± rand(TAU_12)
        let upgraded = DroneNode(at: CGPoint(r: 80, a: a1))
        upgraded.radarUpgrade = true
        upgraded.bulletUpgrade = true
        upgraded.movementUpgrade = true
        return [
            DroneNode(at: CGPoint(r: 80, a: a2)),
            upgraded
        ]
    }
}
