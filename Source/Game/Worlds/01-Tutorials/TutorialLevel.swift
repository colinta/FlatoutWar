////
///  TutorialLevel.swift
//

class TutorialLevel: Level {

    required init() {
        super.init()
        levelSelect = .tutorial
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func introduceDrone() {
        let drone = DroneNode()
        drone.position = CGPoint(-30, -60)
        addArmyNode(drone)
    }

    func disableRapidFire() {
        (playerNode as! BasePlayerNode).forceFireEnabled = false
    }

}
