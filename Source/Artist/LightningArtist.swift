//
//  LightningArtist.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/31/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

struct LightningBolt {
    let offsets: [CGFloat]

    init() {
        let offsetCount: Int = rand(50...100)
        var offsets: [CGFloat] = []
        var tmpOffsets = [(left: LightningBolt.randomOffset(), right: LightningBolt.randomOffset())]
        for _ in 0...offsetCount {
            var current = tmpOffsets.last!
            current.left += LightningBolt.randomOffset()
            current.right += LightningBolt.randomOffset()
            tmpOffsets << current
        }
        for i in 0...offsetCount {
            let amtRight = CGFloat(i) / CGFloat(offsetCount)
            let amtLeft = 1 - amtRight
            let amt = amtLeft * tmpOffsets[i].left + amtRight * tmpOffsets[offsetCount - i].right
            offsets << amt
        }
        self.offsets = offsets
    }

    static func randomOffset() -> CGFloat {
        return rand(-1...1) * 2
    }
}

class LightningArtist: Artist {
    var color = UIColor(hex: 0xFFFFFF)
    var dt: CGFloat = 0.01667
    var rate: CGFloat = 2
    typealias BoltEntry = (phase: CGFloat, bolt: LightningBolt)
    var bolts: [BoltEntry] = []

    required init() {
        super.init()

        let boltCount = 8
        for i in 0..<boltCount {
            bolts << newEntry(CGFloat(i + 1) / CGFloat(boltCount))
        }
    }

    private func newEntry(phase: CGFloat) -> BoltEntry {
        return (phase: phase, bolt: LightningBolt())
    }

    override func draw(context: CGContext) {
        for (index, entry) in bolts.enumerate() {
            let phase = entry.phase - dt * rate
            if phase < 0 {
                bolts[index] = newEntry(1)
            }
            else {
                bolts[index] = (phase: phase, entry.bolt)
            }
        }

        let p1 = CGPoint(x: 0, y: size.height / 2)
        let p2 = CGPoint(x: size.width, y: size.height / 2)
        let offsetAngle = TAU_4
        for entry in bolts {
            let offsets = entry.bolt.offsets
            CGContextMoveToPoint(context, p1.x, p1.y)
            let offsetCount = offsets.count
            for i in 0..<offsetCount {
                let offset = offsets[i]
                let amt = CGFloat(i) / CGFloat(offsetCount - 1)
                let p = CGPoint(
                    x: p1.x + (p2.x - p1.x) * amt,
                    y: p1.y + (p2.y - p1.y) * amt) + CGPoint(r: offset, a: offsetAngle)
                CGContextAddLineToPoint(context, p.x, p.y)
            }

            CGContextSetAlpha(context, entry.phase)
            CGContextSetShadowWithColor(context, .Zero, 3, color.CGColor)
            CGContextSetStrokeColorWithColor(context, color.CGColor)
            CGContextDrawPath(context, .Stroke)
        }
    }
}
