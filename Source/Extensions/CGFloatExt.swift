//
//  CGFloatExt.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/16/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension CGFloat {
    var degrees: CGFloat {
        return CGFloat(self) / 360 * TAU
    }

    var pixels: CGFloat {
        return CGFloat(self) / UIScreen.mainScreen().scale
    }
}

extension Double {
    var degrees: CGFloat {
        return CGFloat(self) / 360 * TAU
    }

    var pixels: CGFloat {
        return CGFloat(self) / UIScreen.mainScreen().scale
    }
}


extension Int {
    var degrees: CGFloat {
        return CGFloat(self) / 360 * TAU
    }

    var pixels: CGFloat {
        return CGFloat(self) / UIScreen.mainScreen().scale
    }
}
