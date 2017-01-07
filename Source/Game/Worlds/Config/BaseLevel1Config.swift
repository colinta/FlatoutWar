////
///  BaseLevel1Config.swift
//

class BaseLevel1Config: BaseLevelConfig {
    override var possibleExperience: Int { return 225 }
    override var availablePlayers: [Node] {
        return [DroneNode(at: CGPoint(r: 80, a: rand(TAU)))]
    }

    override func nextLevel() -> Level {
        return BaseLevel2()
    }
}
