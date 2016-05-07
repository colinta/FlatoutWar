//
//  BigFont.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let defaultSize = CGSize(5, 10)
let BigFont = Font(
    stroke: 0.5,
    scale: 4,
    space: 3,
    size: defaultSize,
    art: [
    " ": Letter(style: .Loop, size: defaultSize, points: [[CGPoint]]()),
    "-": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(0.5, 3.5),
        CGPoint(4.5, 3.5),
        CGPoint(4.5, 4.5),
        CGPoint(0.5, 4.5),
    ]]),
    ">": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(5, 4),
        CGPoint(0, 8),
    ]]),
    "<": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(5, 0),
        CGPoint(0, 4),
        CGPoint(5, 8),
    ]]),
    "|": Letter(style: .Line, size: defaultSize, points: [[
            CGPoint(2.5, 0),
            CGPoint(2.5, 8)
        ]]
    ),
    "?": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(1.5, 1.5),
            CGPoint(1.5, 2),
            CGPoint(1, 2.5),
            CGPoint(0.5, 2.5),
            CGPoint(0, 2),
            CGPoint(0, 1),
            CGPoint(1, 0),
            CGPoint(4, 0),
            CGPoint(5, 1),
            CGPoint(5, 3),
            CGPoint(3, 5),
            CGPoint(3, 6),
            CGPoint(2, 6),
            CGPoint(2, 4.5),
            CGPoint(3.5, 3),
            CGPoint(3.5, 1.5),
        ], [
            CGPoint(2, 8),
            CGPoint(2, 7),
            CGPoint(3, 7),
            CGPoint(3, 8)
        ]]
    ),
    "×": Letter(style: .Line, size: defaultSize, points: [[
            CGPoint(0, 1.5),
            CGPoint(5, 6.5),
        ], [
            CGPoint(0, 6.5),
            CGPoint(5, 1.5),
        ]]
    ),
    "A": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(2, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 7),
            CGPoint(3, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(3, 8),
            CGPoint(3, 6),
            CGPoint(2, 6),
            CGPoint(2, 8),
        ], [
            CGPoint(2.25, 3),
            CGPoint(2.5, 2.5),
            CGPoint(2.75, 3)
        ]]
    ),
    "B": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(3.75, 0),
            CGPoint(4.75, 1.5),
            CGPoint(4.75, 2.5),
            CGPoint(3.75, 3.5),
            CGPoint(5, 4.75),
            CGPoint(5, 6),
            CGPoint(4.5, 7),
            CGPoint(0, 7),
            CGPoint(4.5, 7),
            CGPoint(4, 8),
            CGPoint(0, 8),
        ], [
            CGPoint(1.75, 1.75),
            CGPoint(2.75, 1.75),
        ], [
            CGPoint(1.75, 5.25),
            CGPoint(3.25, 5.25),
        ]]
    ),
    "C": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(4.5, 7),
            CGPoint(0, 7),
            CGPoint(0, 1),
            CGPoint(1, 0),
            CGPoint(5, 0),
            CGPoint(4.5, 2.5),
            CGPoint(2, 2.5),
            CGPoint(2, 5),
            CGPoint(4.5, 5),
            CGPoint(4.5, 8),
        ]]
    ),
    "D": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(4, 0),
            CGPoint(5, 1),
            CGPoint(5, 7),
            CGPoint(4, 8),
        ], [
            CGPoint(2.25, 3),
            CGPoint(2.75, 3),
            CGPoint(2.75, 4),
            CGPoint(2.25, 4)
        ]]
    ),
    "E": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2.5),
            CGPoint(2, 2.5),
            CGPoint(4, 2.5),
            CGPoint(3, 5),
            CGPoint(2, 5),
            CGPoint(5, 5),
            CGPoint(5, 8)
        ]]
    ),
    "F": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2),
            CGPoint(2, 2),
            CGPoint(4, 2),
            CGPoint(3, 4),
            CGPoint(2, 4),
            CGPoint(2, 7),
            CGPoint(0, 7),
            CGPoint(2, 7),
            CGPoint(2, 8)
        ]]
    ),
    "G": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2.5),
            CGPoint(2, 2.5),
            CGPoint(2, 5),
            CGPoint(3, 5),
            CGPoint(3, 4),
            CGPoint(5, 4),
            CGPoint(5, 8),
        ]]
    ),
    "H": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(2, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(2, 0),
            CGPoint(2, 3),
            CGPoint(3, 3),
            CGPoint(3, 0),
            CGPoint(5, 0),
            CGPoint(5, 7),
            CGPoint(3, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(3, 8),
            CGPoint(3, 5),
            CGPoint(2, 5),
            CGPoint(2, 8),
        ]]
    ),
    "I": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5.5, 0),
            CGPoint(4.5, 2),
            CGPoint(3.25, 2),
            CGPoint(3.25, 6),
            CGPoint(5, 6),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(-0.5, 8),
            CGPoint(0.5, 6),
            CGPoint(1.75, 6),
            CGPoint(1.75, 2),
            CGPoint(0, 2)
        ]]
    ),
    "J": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5.5, 0),
            CGPoint(4.5, 2),
            CGPoint(3.75, 2),
            CGPoint(3.75, 7),
            CGPoint(0, 7),
            CGPoint(3.75, 7),
            CGPoint(3.75, 8),
            CGPoint(-0.5, 8),
            CGPoint(0.5, 6),
            CGPoint(2.25, 6),
            CGPoint(2.25, 2),
            CGPoint(0, 2)
        ]]
    ),
    "K": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(2, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(2, 0),
            CGPoint(2, 3),
            CGPoint(4, 0),
            CGPoint(5, 0),
            CGPoint(5, 1),
            CGPoint(3, 4),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(4, 8),
            CGPoint(2, 5),
            CGPoint(2, 8),
        ], [
            CGPoint(5, 7),
            CGPoint(3.3333333333333335, 7),
        ]]
    ),
    "L": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(5, 8),
            CGPoint(4.5, 7),
            CGPoint(0, 7),
            CGPoint(4.5, 7),
            CGPoint(4, 6),
            CGPoint(2, 6),
            CGPoint(2, 0),
            CGPoint(0, 0)
        ]]
    ),
    "M": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(1.5, 8),
            CGPoint(1.5, 7),
            CGPoint(0, 7),
            CGPoint(1.5, 7),
            CGPoint(1.5, 2.5),
            CGPoint(2.5, 3.5),
            CGPoint(3.5, 2.5),
            CGPoint(3.5, 7),
            CGPoint(5, 7),
            CGPoint(3.5, 7),
            CGPoint(3.5, 8),
            CGPoint(5, 8),
            CGPoint(5, 0),
            CGPoint(0, 0)
        ]]
    ),
    "N": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(1.5, 8),
            CGPoint(1.5, 7),
            CGPoint(0, 7),
            CGPoint(1.5, 7),
            CGPoint(1.5, 2.5),
            CGPoint(3.5, 4.5),
            CGPoint(3.5, 7),
            CGPoint(5, 7),
            CGPoint(3.5, 7),
            CGPoint(3.5, 8),
            CGPoint(5, 8),
            CGPoint(5, 0),
            CGPoint(3.5, 0),
            CGPoint(3.5, 2),
            CGPoint(1.5, 0),
            CGPoint(0, 0)
        ]]
    ),
    "O": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 8),
        ], [
            CGPoint(2.25, 3),
            CGPoint(2.75, 3),
            CGPoint(2.75, 4),
            CGPoint(2.25, 4)
        ]]
    ),
    "P": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 4),
            CGPoint(2, 4),
            CGPoint(2, 7),
            CGPoint(0, 7),
            CGPoint(2, 7),
            CGPoint(2, 8),
        ], [
            CGPoint(2, 1.5),
            CGPoint(3, 1.5),
            CGPoint(3.25, 2),
            CGPoint(2, 2)
        ]]
    ),
    "Q": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 8),
            CGPoint(2.75, 8),
        ], [
            CGPoint(2.25, 3),
            CGPoint(2.75, 3),
            CGPoint(2.75, 4),
            CGPoint(2.25, 4)
        ], [
            CGPoint(2.75, 9),
            CGPoint(2.25, 9),
            CGPoint(2.25, 6),
            CGPoint(2.75, 6),
        ]]
    ),
    "R": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 4),
            CGPoint(3, 4),
            CGPoint(5, 8),
            CGPoint(4.5, 7),
            CGPoint(0, 7),
            CGPoint(4.5, 7),
            CGPoint(5, 8),
            CGPoint(2, 8),
            CGPoint(2, 6),
            CGPoint(2, 8),
            CGPoint(0, 8),
        ], [
            CGPoint(2, 1.5),
            CGPoint(3, 1.5),
            CGPoint(3.25, 2),
            CGPoint(2, 2)
        ]]
    ),
    "S": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(4, 3),
            CGPoint(2, 3),
            CGPoint(5, 3),
            CGPoint(5, 7),
            CGPoint(0.5, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(0, 8),
            CGPoint(1, 5),
            CGPoint(3, 5),
            CGPoint(0, 5)
        ]]
    ),
    "T": Letter(style: .Loop, size: CGSize(5.6, defaultSize.height), points: [[
            CGPoint(0, 0),
            CGPoint(5.5, 0),
            CGPoint(4.5, 2),
            CGPoint(3.25, 2),
            CGPoint(3.25, 7),
            CGPoint(1.75, 7),
            CGPoint(3.25, 7),
            CGPoint(3.25, 8),
            CGPoint(1.75, 8),
            CGPoint(1.75, 2),
            CGPoint(0, 2)
        ]]
    ),
    "U": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 0),
            CGPoint(2, 0),
            CGPoint(2, 5.5),
            CGPoint(3, 5.5),
            CGPoint(3, 0),
            CGPoint(5, 0),
            CGPoint(5, 8)
        ]]
    ),
    "V": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(2, 0),
            CGPoint(2.5, 2),
            CGPoint(3, 0),
            CGPoint(5, 0),
            CGPoint(3, 8),
            CGPoint(2, 8),
        ], [
            CGPoint(3.25, 7),
            CGPoint(1.75, 7),
        ]]
    ),
    "W": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(1.5, 0),
            CGPoint(1.5, 5.5),
            CGPoint(2.5, 4.5),
            CGPoint(3.5, 5.5),
            CGPoint(3.5, 0),
            CGPoint(5, 0),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(0, 8)
        ]]
    ),
    "X": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(2, 0),
            CGPoint(2.5, 2),
            CGPoint(3, 0),
            CGPoint(5, 0),
            CGPoint(5, 2.5),
            CGPoint(4.5, 4),
            CGPoint(5, 5.5),
            CGPoint(5, 8),
            CGPoint(3, 8),
            CGPoint(2.5, 6),
            CGPoint(2, 8),
            CGPoint(0, 8),
            CGPoint(0, 5.5),
            CGPoint(0.5, 4),
            CGPoint(0, 2.5),
        ], [
            CGPoint(0, 7),
            CGPoint(2.25, 7),
        ], [
            CGPoint(2.75, 7),
            CGPoint(5, 7),
        ]]
    ),
    "Y": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(1.75, 0),
            CGPoint(2.5, 1.5),
            CGPoint(3.25, 0),
            CGPoint(5, 0),
            CGPoint(3.25, 4),
            CGPoint(3.25, 7),
            CGPoint(1.75, 7),
            CGPoint(3.25, 7),
            CGPoint(3.25, 8),
            CGPoint(1.75, 8),
            CGPoint(1.75, 4),
        ]]
    ),
    "Z": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2),
            CGPoint(2, 6),
            CGPoint(5, 6),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(0, 8),
            CGPoint(0, 6),
            CGPoint(3, 2),
            CGPoint(0, 2),
        ]]
    ),
    "0": Letter(style: .Loop, size: CGSize(4, defaultSize.height), points: [[
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(4, 7),
            CGPoint(0, 7),
            CGPoint(0, 1),
            CGPoint(1, 0),
            CGPoint(4, 0),
            CGPoint(4, 1),
            CGPoint(0, 7),
            CGPoint(4, 1),
            CGPoint(4, 8)
        ]]
    ),
    "1": Letter(style: .Loop, size: CGSize(3, defaultSize.height), points: [[
            CGPoint(0.5, 1),
            CGPoint(-0.25, 1),
            CGPoint(2, 0),
            CGPoint(2, 7),
            CGPoint(0.5, 7),
            CGPoint(2, 7),
            CGPoint(2, 8),
            CGPoint(0.5, 8)
        ]]
    ),
    "2": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 1),
            CGPoint(1, 0),
            CGPoint(4, 0),
            CGPoint(5, 1),
            CGPoint(5, 2),
            CGPoint(2, 6),
            CGPoint(2, 6),
            CGPoint(5, 6),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(0, 8),
            CGPoint(0, 6),
            CGPoint(3, 2),
            CGPoint(1, 2),
        ]]
    ),
    "3": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2),
            CGPoint(4, 3),
            CGPoint(5, 4),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(0, 8),
            CGPoint(0, 4.5),
            CGPoint(2, 4.5),
            CGPoint(0.5, 4.5),
            CGPoint(0.5, 4),
            CGPoint(3, 2),
            CGPoint(0, 2)
        ]]
    ),
    "4": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(4, 0),
            CGPoint(4, 4),
            CGPoint(5, 4),
            CGPoint(5, 6),
            CGPoint(4, 6),
            CGPoint(4, 7),
            CGPoint(2.5, 7),
            CGPoint(4, 7),
            CGPoint(4, 8),
            CGPoint(2.5, 8),
            CGPoint(2.5, 6),
            CGPoint(0, 6),
            CGPoint(0, 4),
        ], [
            CGPoint(2.5, 4),
            CGPoint(2.5, 3.5),
            CGPoint(2, 4)
        ]]
    ),
    "5": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2),
            CGPoint(2, 2),
            CGPoint(2, 3),
            CGPoint(4, 3),
            CGPoint(5, 4),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(0, 8),
            CGPoint(0, 5.5),
            CGPoint(3, 5.5),
            CGPoint(2, 4.5),
            CGPoint(0, 4.5),
            CGPoint(0, 4)
        ]]
    ),
    "6": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(5, 0),
            CGPoint(3.5, 0),
            CGPoint(0, 2.5),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 8),
            CGPoint(5, 8),
            CGPoint(5, 5),
            CGPoint(4.5, 3.5),
            CGPoint(2.5, 3.5),
            CGPoint(2.5, 3),
            CGPoint(5, 1),
        ], [
            CGPoint(2, 5.5),
            CGPoint(3.5, 5.5)
        ]]
    ),
    "7": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 2),
            CGPoint(5, 2),
            CGPoint(3.75, 7),
            CGPoint(1.75, 7),
            CGPoint(3.75, 7),
            CGPoint(3.5, 8),
            CGPoint(1.5, 8),
            CGPoint(3, 2),
            CGPoint(0, 2)
        ]]
    ),
    "8": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 3),
            CGPoint(3.5, 3),
            CGPoint(5, 3),
            CGPoint(5, 8),
            CGPoint(0, 8),
            CGPoint(0, 7),
            CGPoint(5, 7),
            CGPoint(0, 7),
            CGPoint(0, 3),
            CGPoint(1.5, 3),
            CGPoint(0, 3),
        ], [
            CGPoint(1.75, 1.5),
            CGPoint(3.25, 1.5),
        ], [
            CGPoint(1.75, 5),
            CGPoint(3.25, 5)
        ]]
    ),
    "9": Letter(style: .Loop, size: defaultSize, points: [[
            CGPoint(0, 0),
            CGPoint(5, 0),
            CGPoint(5, 7),
            CGPoint(3, 7),
            CGPoint(5, 7),
            CGPoint(5, 8),
            CGPoint(3, 8),
            CGPoint(3, 4),
            CGPoint(0.5, 4),
            CGPoint(0, 3),
        ], [
            CGPoint(1.5, 1.5),
            CGPoint(3, 1.5),
            CGPoint(3, 2.5),
            CGPoint(2, 2.5)
        ]]
    )
])
