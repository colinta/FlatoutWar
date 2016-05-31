//
//  ResourcePercent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/14/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ResourcePercent: LabelPercent {

    required init() {
        fatalError("init() has not been implemented")
    }

    required init(goal: Int) {
        super.init(goal: goal)

        percent.style = .Resource
        fixedPosition = .BottomRight(x: -size.width / 2, y: 15)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
