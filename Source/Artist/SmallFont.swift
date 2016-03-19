//
//  SmallFont.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let defaultSize = CGSize(width: 4, height: 6)
let SmallFont: Font = [
    " ": Letter(style: .Line, size: CGSize(width: 3, height: 6), points: [[CGPoint]]()),
    ".": Letter(style: .Line, size: CGSize(width: 0.5, height: 6), points: [[
        CGPoint(x: -0.25, y: 6),
        CGPoint(x: 0.25, y: 6),
    ]]),
    "!": Letter(style: .Line, size: CGSize(width: 0.5, height: 6), points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 5),
    ], [
        CGPoint(x: -0.25, y: 6),
        CGPoint(x: 0.25, y: 6),
    ]]),
    "↓": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 6),
    ], [
        CGPoint(x: 0, y: 4),
        CGPoint(x: 2, y: 6),
        CGPoint(x: 4, y: 4),
    ]]),
    "→": Letter(style: .Line, size: CGSize(width: 6, height: 4), points: [[
        CGPoint(x: 0, y: 2),
        CGPoint(x: 6, y: 2),
    ], [
        CGPoint(x: 4, y: 0),
        CGPoint(x: 6, y: 2),
        CGPoint(x: 4, y: 4),
    ]]),
    "-": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
    ]]),
    ">": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 0, y: 6),
    ]]),
    "<": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 6),
    ]]),
    "0": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
    ], [
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 6),
    ]]),
    "1": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 2),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 6.25),
    ]]),
    "2": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
    ]]),
    "3": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 1, y: 3),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
    ]]),
    "4": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 3, y: 0),
        CGPoint(x: 0, y: 4),
        CGPoint(x: 4, y: 4),
    ], [
        CGPoint(x: 3, y: 1),
        CGPoint(x: 3, y: 6.25),
    ]]),
    "5": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
    ]]),
    "6": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 3, y: 3),
    ]]),
    "7": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 6.25),
    ]]),
    "8": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 0, y: 0),
    ], [
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
    ]]),
    "9": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 3, y: 3),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6.25),
    ]]),
    "A": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 6.25),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6.25),
    ], [
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
    ]]),
    "B": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 3, y: 0),
        CGPoint(x: 3, y: 3),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
    ]]),
    "C": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
    ]]),
    "D": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 3, y: 0),
        CGPoint(x: 4, y: 1),
        CGPoint(x: 4, y: 5),
        CGPoint(x: 3, y: 6),
        CGPoint(x: 0, y: 6),
    ]]),
    "E": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
    ], [
        CGPoint(x: 0, y: 3),
        CGPoint(x: 3, y: 3),
    ]]),
    "F": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 6.25),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
    ], [
        CGPoint(x: 0, y: 3),
        CGPoint(x: 1.5, y: 3),
    ]]),
    "G": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 3, y: 3),
    ]]),
    "H": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 6.25),
    ], [
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
    ], [
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6.25),
    ]]),
    "I": Letter(style: .Line, size: CGSize(width: 2, height: 6), points: [[
        CGPoint(x: 1, y: 0),
        CGPoint(x: 1, y: 6.25),
    ]]),
    "J": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
    ]]),
    "K": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
    ]]),
    "L": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
    ]]),
    "M": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 6.25),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6.25),
    ]]),
    "N": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 6.25),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 4, y: -0.25),
    ]]),
    "O": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
    ]]),
    "P": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 6.25),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 0, y: 3),
    ]]),
    "Q": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
    ]]),
    "R": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 6.25),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 0.5, y: 3),
        CGPoint(x: 4, y: 6.25),
    ]]),
    "S": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 4, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 0, y: 6),
    ]]),
    "T": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 0),
    ], [
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 6.25),
    ]]),
    "U": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: -0.25),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 4, y: -0.25),
    ]]),
    "V": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
    ]]),
    "W": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 6),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 4, y: 6),
        CGPoint(x: 4, y: 0),
    ]]),
    "X": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
    ], [
        CGPoint(x: 0, y: 6),
        CGPoint(x: 4, y: 0),
    ]]),
    "Y": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 4, y: 0),
    ], [
        CGPoint(x: 2, y: 3),
        CGPoint(x: 2, y: 6.25),
    ]]),
    "Z": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 4, y: 6),
    ]]),
]
