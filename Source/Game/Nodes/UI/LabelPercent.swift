////
///  LabelPercent.swift
//

class LabelPercent: Node {
    let text = TextNode()
    let percent = PercentBar()
    let goal: Int?
    let max: Int?
    var collected: Int {
        didSet {
            updateSprites()
        }
    }

    required init() {
        fatalError("must provide goal")
    }

    required init(goal: Int?, max: Int?) {
        self.goal = goal
        self.max = max
        self.collected = 0
        super.init()

        text.alignment = .right
        text.font = .tiny
        if let goal = goal {
            text.text = "\(goal)/\(goal)"
        }
        else if let max = max {
            text.text = "\(max)/\(max)"
        }
        self << text

        percent.complete = 0
        self << percent

        var totalWidth: CGFloat = 3 // inner margin
        totalWidth += text.size.width
        totalWidth += percent.size.width

        size = CGSize(totalWidth, Swift.max(text.size.height, percent.size.height))
        text.position = CGPoint(x: -size.width / 2 + text.size.width)
        percent.position = CGPoint(x: size.width / 2 - percent.size.width / 2)
        updateSprites()
    }

    func gain(_ amt: Int) {
        self.collected += amt
    }

    func spend(_ amt: Int) {
        self.collected -= amt
    }

    private func updateSprites() {
        if let goal = goal {
            text.text = "\(collected)/\(goal)"
        }
        else {
            text.text = "\(collected)"
        }

        if goal == 0 {
            percent.complete = 1
            text.color = WhiteColor
        }
        else if let goal = goal ?? max {
            percent.complete = CGFloat(collected) / CGFloat(goal)
            if percent.complete >= 1 {
                text.color = 0x1BFF00
            }
            else if percent.complete > 0.5 {
                text.color = interpolateHex(percent.complete, from: (0.5, 1), to: (0xFD8608, 0xFFFA00))
            }
            else {
                text.color = interpolateHex(percent.complete, from: (0, 0.5), to: (0xDD0000, 0xFD8608))
            }
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
