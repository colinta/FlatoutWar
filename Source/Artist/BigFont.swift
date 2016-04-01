//
//  BigFont.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let defaultSize = CGSize(width: 5, height: 8)
let BigFont = Font(
    stroke: 0.5,
    scale: 4,
    space: 3,
    font: [
    " ": Letter(style: .Loop, size: defaultSize, points: [[CGPoint]]()),
    "-": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0.5, y: 3.5),
        CGPoint(x: 4.5, y: 3.5),
        CGPoint(x: 4.5, y: 4.5),
        CGPoint(x: 0.5, y: 4.5),
    ]]),
    ">": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 5, y: 4),
        CGPoint(x: 0, y: 8),
    ]]),
    "<": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 5, y: 0),
        CGPoint(x: 0, y: 4),
        CGPoint(x: 5, y: 8),
    ]]),
    "|": Letter(style: .Line, size: defaultSize, points: [[
            CGPoint(x: 2.5, y: 0),
            CGPoint(x: 2.5, y: 8)
        ]]
    ),
    "?": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 1.5, y: 1.5),
            CGPoint(x: 1.5, y: 2),
            CGPoint(x: 1, y: 2.5),
            CGPoint(x: 0.5, y: 2.5),
            CGPoint(x: 0, y: 2),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 4, y: 0),
            CGPoint(x: 5, y: 1),
            CGPoint(x: 5, y: 3),
            CGPoint(x: 3, y: 5),
            CGPoint(x: 3, y: 6),
            CGPoint(x: 2, y: 6),
            CGPoint(x: 2, y: 4.5),
            CGPoint(x: 3.5, y: 3),
            CGPoint(x: 3.5, y: 1.5),
        ], [
            CGPoint(x: 2, y: 8),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 3, y: 7),
            CGPoint(x: 3, y: 8)
        ]]
    ),
    "×": Letter(style: .Line, size: defaultSize, points: [[
            CGPoint(x: 0, y: 1.5),
            CGPoint(x: 5, y: 6.5),
        ], [
            CGPoint(x: 0, y: 6.5),
            CGPoint(x: 5, y: 1.5),
        ]]
    ),
    "A": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 3, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 3, y: 8),
            CGPoint(x: 3, y: 6),
            CGPoint(x: 2, y: 6),
            CGPoint(x: 2, y: 8),
        ], [
            CGPoint(x: 2.25, y: 3),
            CGPoint(x: 2.5, y: 2.5),
            CGPoint(x: 2.75, y: 3)
        ]]
    ),
    "B": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 3.75, y: 0),
            CGPoint(x: 4.75, y: 1.5),
            CGPoint(x: 4.75, y: 2.5),
            CGPoint(x: 3.75, y: 3.5),
            CGPoint(x: 5, y: 4.75),
            CGPoint(x: 5, y: 6),
            CGPoint(x: 4.5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 4.5, y: 7),
            CGPoint(x: 4, y: 8),
            CGPoint(x: 0, y: 8),
        ], [
            CGPoint(x: 1.75, y: 1.75),
            CGPoint(x: 2.75, y: 1.75),
        ], [
            CGPoint(x: 1.75, y: 5.25),
            CGPoint(x: 3.25, y: 5.25)
        ]]
    ),
    "C": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "D": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 4, y: 0),
            CGPoint(x: 5, y: 1),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 4, y: 8),
        ], [
            CGPoint(x: 2.25, y: 3),
            CGPoint(x: 2.75, y: 3),
            CGPoint(x: 2.75, y: 4),
            CGPoint(x: 2.25, y: 4)
        ]]
    ),
    "E": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 2.5),
            CGPoint(x: 2, y: 2.5),
            CGPoint(x: 4, y: 2.5),
            CGPoint(x: 3, y: 5),
            CGPoint(x: 2, y: 5),
            CGPoint(x: 5, y: 5),
            CGPoint(x: 5, y: 8)
        ]]
    ),
    "F": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 2),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 4, y: 2),
            CGPoint(x: 3, y: 4),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 2, y: 8)
        ]]
    ),
    "G": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "H": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "I": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5.5, y: 0),
            CGPoint(x: 4.5, y: 2),
            CGPoint(x: 3.25, y: 2),
            CGPoint(x: 3.25, y: 6),
            CGPoint(x: 5, y: 6),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: -0.5, y: 8),
            CGPoint(x: 0.5, y: 6),
            CGPoint(x: 1.75, y: 6),
            CGPoint(x: 1.75, y: 2),
            CGPoint(x: 0, y: 2)
        ]]
    ),
    "J": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "K": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "L": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 4.5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 4.5, y: 7),
            CGPoint(x: 4, y: 6),
            CGPoint(x: 2, y: 6),
            CGPoint(x: 2, y: 0),
            CGPoint(x: 0, y: 0)
        ]]
    ),
    "M": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 1.5, y: 8),
            CGPoint(x: 1.5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 1.5, y: 7),
            CGPoint(x: 1.5, y: 2.5),
            CGPoint(x: 2.5, y: 3.5),
            CGPoint(x: 3.5, y: 2.5),
            CGPoint(x: 3.5, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 3.5, y: 7),
            CGPoint(x: 3.5, y: 8),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 0, y: 0)
        ]]
    ),
    "N": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 1.5, y: 8),
            CGPoint(x: 1.5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 1.5, y: 7),
            CGPoint(x: 1.5, y: 2.5),
            CGPoint(x: 3.5, y: 4.5),
            CGPoint(x: 3.5, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 3.5, y: 7),
            CGPoint(x: 3.5, y: 8),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 3.5, y: 0),
            CGPoint(x: 3.5, y: 2),
            CGPoint(x: 1.5, y: 0),
            CGPoint(x: 0, y: 0)
        ]]
    ),
    "O": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 8),
        ], [
            CGPoint(x: 2.25, y: 3),
            CGPoint(x: 2.75, y: 3),
            CGPoint(x: 2.75, y: 4),
            CGPoint(x: 2.25, y: 4)
        ]]
    ),
    "P": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 4),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 2, y: 8),
        ], [
            CGPoint(x: 2, y: 1.5),
            CGPoint(x: 3, y: 1.5),
            CGPoint(x: 3.25, y: 2),
            CGPoint(x: 2, y: 2)
        ]]
    ),
    "Q": Letter(style: .Loop, size: defaultSize + CGSize(height: 1), points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 2.75, y: 8),
        ], [
            CGPoint(x: 2.25, y: 3),
            CGPoint(x: 2.75, y: 3),
            CGPoint(x: 2.75, y: 4),
            CGPoint(x: 2.25, y: 4)
        ], [
            CGPoint(x: 2.75, y: 9),
            CGPoint(x: 2.25, y: 9),
            CGPoint(x: 2.25, y: 6),
            CGPoint(x: 2.75, y: 6),
        ]]
    ),
    "R": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 4),
            CGPoint(x: 3, y: 4),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 4.5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 4.5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 2, y: 8),
            CGPoint(x: 2, y: 6),
            CGPoint(x: 2, y: 8),
            CGPoint(x: 0, y: 8),
        ], [
            CGPoint(x: 2, y: 1.5),
            CGPoint(x: 3, y: 1.5),
            CGPoint(x: 3.25, y: 2),
            CGPoint(x: 2, y: 2)
        ]]
    ),
    "S": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 4, y: 3),
            CGPoint(x: 2, y: 3),
            CGPoint(x: 5, y: 3),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0.5, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 0, y: 8),
            CGPoint(x: 1, y: 5),
            CGPoint(x: 3, y: 5),
            CGPoint(x: 0, y: 5)
        ]]
    ),
    "T": Letter(style: .Loop, size: CGSize(width: 5.6, height: 8), points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5.5, y: 0),
            CGPoint(x: 4.5, y: 2),
            CGPoint(x: 3.25, y: 2),
            CGPoint(x: 3.25, y: 7),
            CGPoint(x: 1.75, y: 7),
            CGPoint(x: 3.25, y: 7),
            CGPoint(x: 3.25, y: 8),
            CGPoint(x: 1.75, y: 8),
            CGPoint(x: 1.75, y: 2),
            CGPoint(x: 0, y: 2)
        ]]
    ),
    "U": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 2, y: 0),
            CGPoint(x: 2, y: 5.5),
            CGPoint(x: 3, y: 5.5),
            CGPoint(x: 3, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 8)
        ]]
    ),
    "V": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "W": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1.5, y: 0),
            CGPoint(x: 1.5, y: 5.5),
            CGPoint(x: 2.5, y: 4.5),
            CGPoint(x: 3.5, y: 5.5),
            CGPoint(x: 3.5, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "X": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "Y": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "Z": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 8)
        ]]
    ),
    "0": Letter(style: .Loop, size: CGSize(width: 4, height: 8), points: [[
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 4, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 4, y: 0),
            CGPoint(x: 4, y: 1),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 4, y: 1),
            CGPoint(x: 4, y: 8)
        ]]
    ),
    "1": Letter(style: .Loop, size: CGSize(width: 3, height: 8), points: [[
            CGPoint(x: 0.5, y: 1),
            CGPoint(x: -0.25, y: 1),
            CGPoint(x: 2, y: 0),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 0.5, y: 7),
            CGPoint(x: 2, y: 7),
            CGPoint(x: 2, y: 8),
            CGPoint(x: 0.5, y: 8)
        ]]
    ),
    "2": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 4, y: 0),
            CGPoint(x: 5, y: 1),
            CGPoint(x: 5, y: 2),
            CGPoint(x: 2, y: 6),
            CGPoint(x: 2, y: 6),
            CGPoint(x: 5, y: 6),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 6),
            CGPoint(x: 3, y: 2),
            CGPoint(x: 1, y: 2),
        ]]
    ),
    "3": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 2),
            CGPoint(x: 4, y: 3),
            CGPoint(x: 5, y: 4),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 4.5),
            CGPoint(x: 2, y: 4.5),
            CGPoint(x: 0.5, y: 4.5),
            CGPoint(x: 0.5, y: 4),
            CGPoint(x: 3, y: 2),
            CGPoint(x: 0, y: 2)
        ]]
    ),
    "4": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 4, y: 0),
            CGPoint(x: 4, y: 4),
            CGPoint(x: 5, y: 4),
            CGPoint(x: 5, y: 6),
            CGPoint(x: 4, y: 6),
            CGPoint(x: 4, y: 7),
            CGPoint(x: 2.5, y: 7),
            CGPoint(x: 4, y: 7),
            CGPoint(x: 4, y: 8),
            CGPoint(x: 2.5, y: 8),
            CGPoint(x: 2.5, y: 6),
            CGPoint(x: 0, y: 6),
            CGPoint(x: 0, y: 4),
        ], [
            CGPoint(x: 2.5, y: 4),
            CGPoint(x: 2.5, y: 3.5),
            CGPoint(x: 2, y: 4)
        ]]
    ),
    "5": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 2),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 2, y: 3),
            CGPoint(x: 4, y: 3),
            CGPoint(x: 5, y: 4),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 5.5),
            CGPoint(x: 3, y: 5.5),
            CGPoint(x: 2, y: 4.5),
            CGPoint(x: 0, y: 4.5),
            CGPoint(x: 0, y: 4)
        ]]
    ),
    "6": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 5, y: 0),
            CGPoint(x: 3.5, y: 0),
            CGPoint(x: 0, y: 2.5),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 8),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 5, y: 5),
            CGPoint(x: 4.5, y: 3.5),
            CGPoint(x: 2.5, y: 3.5),
            CGPoint(x: 2.5, y: 3),
            CGPoint(x: 5, y: 1),
        ], [
            CGPoint(x: 2, y: 5.5),
            CGPoint(x: 3.5, y: 5.5)
        ]]
    ),
    "7": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 2),
            CGPoint(x: 5, y: 2),
            CGPoint(x: 3.75, y: 7),
            CGPoint(x: 1.75, y: 7),
            CGPoint(x: 3.75, y: 7),
            CGPoint(x: 3.5, y: 8),
            CGPoint(x: 1.5, y: 8),
            CGPoint(x: 3, y: 2),
            CGPoint(x: 0, y: 2)
        ]]
    ),
    "8": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 3),
            CGPoint(x: 3.5, y: 3),
            CGPoint(x: 5, y: 3),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 0, y: 8),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 0, y: 7),
            CGPoint(x: 0, y: 3),
            CGPoint(x: 1.5, y: 3),
            CGPoint(x: 0, y: 3),
        ], [
            CGPoint(x: 1.75, y: 1.5),
            CGPoint(x: 3.25, y: 1.5),
        ], [
            CGPoint(x: 1.75, y: 5),
            CGPoint(x: 3.25, y: 5)
        ]]
    ),
    "9": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(x: 0, y: 0),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 3, y: 7),
            CGPoint(x: 5, y: 7),
            CGPoint(x: 5, y: 8),
            CGPoint(x: 3, y: 8),
            CGPoint(x: 3, y: 4),
            CGPoint(x: 0.5, y: 4),
            CGPoint(x: 0, y: 3),
        ], [
            CGPoint(x: 1.5, y: 1.5),
            CGPoint(x: 3, y: 1.5),
            CGPoint(x: 3, y: 2.5),
            CGPoint(x: 2, y: 2.5)
        ]]
    )
])
