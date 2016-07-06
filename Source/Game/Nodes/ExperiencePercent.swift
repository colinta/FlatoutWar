//
//  ExperiencePercent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/14/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ExperiencePercent: LabelPercent {

    required init() {
        fatalError("init() has not been implemented")
    }

    convenience init(goal: Int) {
        self.init(goal: goal, max: nil)
    }

    required init(goal: Int?, max: Int?) {
        super.init(goal: goal, max: max)

        percent.style = .Experience
        fixedPosition = .BottomRight(x: -size.width / 2, y: 30)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
