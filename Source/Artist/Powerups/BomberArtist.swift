//
//  BomberArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
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
