//
//  ResourcePercent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/14/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class ResourcePercent: Node {
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

        var totalWidth: CGFloat = 3 // inner margin
        text.text = "\(goal)/\(goal)"
        text.font = .Tiny
        totalWidth += text.size.width
        self << text

        percent.complete = 0
        percent.style = .Resource
        totalWidth += percent.size.width
        self << percent

        size = CGSize(totalWidth, max(text.size.height, percent.size.height))
        text.position = CGPoint(x: -size.width / 2 + text.size.width / 2)
        percent.position = CGPoint(x: size.width / 2 - percent.size.width / 2)
        updateSprites()

        fixedPosition = .BottomRight(x: -totalWidth / 2, y: 15)
    }

    func gain(amt: Int) {
        self.collected += amt
    }

    private func updateSprites() {
        text.text = "\(collected)/\(goal)"
        if goal == 0 {
            percent.complete = 1
        }
        else {
            percent.complete = CGFloat(collected) / CGFloat(goal)
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
