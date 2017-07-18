////
///  TinyFont.swift
//

private let defaultSize = CGSize(2, 5)
let TinyFont = Font(
    stroke: 0.5,
    scale: 2,
    space: 0.75,
    verticalSpace: 2,
    size: defaultSize,
    art: [
    ".": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(1, 1),
        CGPoint(1, 3),
        ]]),
    "/": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(2, 0),
        CGPoint(0, 5),
        ]]),
    "∞": Letter(style: .loop, size: CGSize(4, defaultSize.height), points: [[
        CGPoint(0, 1.5),
        CGPoint(0.5, 0.5),
        CGPoint(1.5, 0.5),
        CGPoint(2.5, 2.5),
        CGPoint(3.5, 2.5),
        CGPoint(4, 1.5),
        CGPoint(3.5, 0.5),
        CGPoint(2.5, 0.5),
        CGPoint(1.5, 2.5),
        CGPoint(0.5, 2.5),
        ]]),
    "0": Letter(style: .loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 0),
        CGPoint(2, 3),
        CGPoint(0, 3),
    ], [
        CGPoint(2, 0),
        CGPoint(0, 3),
    ]]),
    "1": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(0, 1),
        CGPoint(1, 0),
        CGPoint(1, 3.25),
    ]]),
    "2": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 0),
        CGPoint(2, 1.5),
        CGPoint(0, 1.5),
        CGPoint(0, 3),
        CGPoint(2, 3),
    ]]),
    "3": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 0),
        CGPoint(1, 1.5),
        CGPoint(2, 1.5),
        CGPoint(2, 3),
        CGPoint(0, 3),
    ]]),
    "4": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(1.5, 0),
        CGPoint(0, 2),
        CGPoint(2, 2),
    ], [
        CGPoint(1.5, 0.5),
        CGPoint(1.5, 3.25),
    ]]),
    "5": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(2, 0),
        CGPoint(0, 0),
        CGPoint(0, 1.5),
        CGPoint(2, 1.5),
        CGPoint(2, 3),
        CGPoint(0, 3),
    ]]),
    "6": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(2, 0),
        CGPoint(0, 3),
        CGPoint(2, 3),
        CGPoint(2, 1.5),
        CGPoint(1.5, 1.5),
    ]]),
    "7": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 0),
        CGPoint(0, 3.25),
    ]]),
    "8": Letter(style: .loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(0, 1.75),
        CGPoint(2, 1.75),
        CGPoint(0, 1.75),
        CGPoint(0, 3),
        CGPoint(2, 3),
        CGPoint(2, 0),
    ]]),
    "9": Letter(style: .line, size: defaultSize, points: [[
        CGPoint(1.5, 1.5),
        CGPoint(0, 1.5),
        CGPoint(0, 0),
        CGPoint(2, 0),
        CGPoint(2, 3.25),
    ]]),
])
