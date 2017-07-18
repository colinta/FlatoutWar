////
///  OceanLevel.swift
//

class OceanLevel: Level {
    required init() {
        super.init()
        levelSelect = .ocean
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func populateWorld() {
        super.populateWorld()
        generateOcean()
    }

    func generateOcean() {
    }

}
