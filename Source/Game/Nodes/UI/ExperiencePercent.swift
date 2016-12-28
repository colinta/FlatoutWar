////
///  ExperiencePercent.swift
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
