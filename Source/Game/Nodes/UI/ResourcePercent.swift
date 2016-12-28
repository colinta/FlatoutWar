////
///  ResourcePercent.swift
//

class ResourcePercent: LabelPercent {

    required init() {
        fatalError("init() has not been implemented")
    }

    convenience init(max: Int) {
        self.init(goal: nil, max: max)
    }

    required init(goal: Int?, max: Int?) {
        super.init(goal: goal, max: max)

        percent.style = .Resource
        fixedPosition = .BottomRight(x: -size.width / 2, y: 15)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
