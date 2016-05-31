//
//  LabelPercent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/30/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class LabelPercent: Node {
    let text = TextNode()
    let percent = PercentBar()
    let goal: Int
    var collected: Int {
        didSet {
            updateSprites()
        }
    }

    required init() {
        fatalError("must provide goal")
    }

    required init(goal: Int) {
        self.goal = goal
        self.collected = 0
        super.init()

        text.font = .Tiny
        text.text = "\(goal)/\(goal)"
        self << text

        percent.complete = 0
        self << percent

        var totalWidth: CGFloat = 3 // inner margin
        totalWidth += text.size.width
        totalWidth += percent.size.width

        size = CGSize(totalWidth, max(text.size.height, percent.size.height))
        text.position = CGPoint(x: -size.width / 2 + text.size.width / 2)
        percent.position = CGPoint(x: size.width / 2 - percent.size.width / 2)
        updateSprites()
    }

    func gain(amt: Int) {
        self.collected += amt
    }

    func spend(amt: Int) {
        self.collected -= amt
    }

    private func updateSprites() {
        text.text = "\(collected)/\(goal)"

        if goal == 0 {
            percent.complete = 1
            text.color = nil
        }
        else {
            percent.complete = CGFloat(collected) / CGFloat(goal)
            if percent.complete >= 1 {
                text.color = 0x1BFF00
            }
            else if percent.complete > 0.5 {
                text.color = interpolateHex(percent.complete, from: (0.5, 1), to: (0xFFFA00, 0x16D100))
            }
            else {
                text.color = interpolateHex(percent.complete, from: (0, 0.5), to: (0xDD0000, 0xFFFA00))
            }
        }
    }

    required init?(coder: NSCoder) {
        self.goal = coder.decodeInt("goal") ?? 1
        self.collected = coder.decodeInt("collected") ?? 1
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(goal, key: "goal")
        encoder.encode(collected, key: "collected")
    }

}
