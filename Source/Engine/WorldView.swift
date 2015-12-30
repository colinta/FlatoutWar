//
//  WorldView.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class WorldView: SKView {

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            (scene as? WorldScene)?.gameShook()
        }
    }

}
