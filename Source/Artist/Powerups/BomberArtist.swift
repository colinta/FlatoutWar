////
///  BomberArtist.swift
//

class BomberArtist: BomberPowerupArtist {

    required init(numBombs: Int) {
        super.init()
        self.numBombs = numBombs
        size = CGSize(50)
    }

    convenience required init() {
        self.init(numBombs: 8)
    }

}
