////
///  BomberArtist.swift
//

class BomberArtist: BomberPowerupArtist {

    required init(numBombs: Int) {
        super.init()
        self.numBombs = numBombs
        rotation = 0
        size = CGSize(50)
    }

    convenience required init() {
        self.init(numBombs: 8)
    }

}
