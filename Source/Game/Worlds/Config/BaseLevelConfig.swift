////
///  BaseLevelConfig.swift
//

typealias TreeInfo = BaseLevel.TreeInfo

let key = "Config-BaseLevelConfig"
let storage = Storage<[TreeInfo]>(
    get: { defaults in
        guard
            let values = defaults.array(forKey: "\(key)-points"),
            let points: [CGPoint] = (values as? [NSValue])?.map({ $0.cgPointValue }),
            let radii: [CGFloat] = (defaults.array(forKey: "\(key)-radii") as? [Float])?.map({ CGFloat($0) }),
            let alphas: [CGFloat] = (defaults.array(forKey: "\(key)-alphas") as? [Float])?.map({ CGFloat($0) }),
            points.count == radii.count, radii.count == alphas.count
        else { return nil }

        return points.enumerated().map { (index, point) in return TreeInfo(center: point, radius: radii[index], alpha: alphas[index]) }
    },
    set: { (defaults, values) in
        let points: [NSValue] = values.map { info in return NSValue(cgPoint: info.center) }
        let radii: [Float] = values.map { info in return Float(info.radius) }
        let alphas: [Float] = values.map { info in return Float(info.alpha) }
        defaults.set(points, forKey: "\(key)-points")
        defaults.set(radii, forKey: "\(key)-radii")
        defaults.set(alphas, forKey: "\(key)-alphas")
    })

class BaseLevelConfig: LevelConfig {

    override var availablePowerups: [Powerup] { return [
        GrenadePowerup(count: 2),
        LaserPowerup(count: 1),
        MinesPowerup(count: 1),
    ] }

    override var availableArmyNodes: [Node] {
        return [DroneNode(at: CGPoint(r: 80, a: rand(TAU)))]
    }

    var treeCenters: [TreeInfo] {
        get {
            if let info = storage.get() {
                return info
            }

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

            // storage.set(info)
            return info
        }
    }
}

struct Storage<T> {
    typealias Getter = (UserDefaults) -> T?
    typealias Setter = (UserDefaults, T) -> Void
    let getter: Getter
    let setter: Setter

    init(get getter: @escaping Getter, set setter: @escaping Setter) {
        self.getter = getter
        self.setter = setter
    }

    func get() -> T? {
        return getter(UserDefaults.standard)
    }

    func set(_ value: T) {
        setter(UserDefaults.standard, value)
    }
}
