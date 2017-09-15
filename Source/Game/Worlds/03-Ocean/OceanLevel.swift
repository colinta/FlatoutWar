////
///  OceanLevel.swift
//

class OceanLevel: Level {
    var droneNode: Node!
    var upgradedDroneNode: Node!

    required init() {
        super.init()
        levelSelect = .ocean
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func populateWorld() {
        playerNode = Node()
        super.populateWorld()

        for player in players {
            guard let someDrone = player as? DroneNode else { continue }

            if someDrone.radarUpgrade == .true {
                upgradedDroneNode = someDrone
            }
            else {
                droneNode = someDrone
            }
        }

        cameraNode.position = CGPoint(x: 100)
        generateOcean()
    }

    func generateOcean() {
        let size = self.size
        let oceanWidth: CGFloat = 60
        let waveWidth = oceanWidth + 40
        let offset = cameraNode.position

        let ocean = SpriteNode(id: .fillColorBox(size: CGSize(oceanWidth, size.height), color: 0x2895F3))
        ocean.z = .below
        ocean.alpha = 0.6
        ocean.position = offset + CGPoint(size.width / 2 - oceanWidth / 2, 0)
        self << ocean

        timeline.every(4) {
            let start = offset + CGPoint(size.width / 2 + waveWidth / 2, 0)
            let destination = start + CGPoint(x: -waveWidth)
            let wave = SpriteNode(id: .fillColorBox(size: CGSize(waveWidth, size.height), color: 0x2895F3))
            wave.position = start
            wave.moveTo(destination, duration: 3)
            wave.fadeTo(0, duration: 3)
            self << wave
        }
    }

}
