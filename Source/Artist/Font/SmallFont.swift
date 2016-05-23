//
//  SmallFont.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let defaultSize = CGSize(4, 8)
let SmallFont = Font(
    stroke: 0.5,
    scale: 3,
    space: 2,
    size: defaultSize,
    art: [
    " ": Letter(style: .Line, size: CGSize(3, defaultSize.height), points: [[CGPoint]]()),
    "|": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(2, 0),
        CGPoint(2, 8)
    ]]),
    ".": Letter(style: .Line, size: CGSize(0.5, defaultSize.height), points: [[
        CGPoint(-0.25, 6),
        CGPoint(0.25, 6),
    ]]),
    "!": Letter(style: .Line, size: CGSize(0.5, defaultSize.height), points: [[
        CGPoint(0, 0),
        CGPoint(0, 5),
    ], [
        CGPoint(-0.25, 6),
        CGPoint(0.25, 6),
    ]]),
    "$": Letter(style: .Line, size: defaultSize + CGSize(height: 2), points: [[
        CGPoint(3, 2),
        CGPoint(2, 1),
        CGPoint(1, 1),
        CGPoint(0, 2),
        CGPoint(0, 4.5),
        CGPoint(3, 3.5),
        CGPoint(3, 6),
        CGPoint(2, 7),
        CGPoint(1, 7),
        CGPoint(0, 6),
    ], [
        CGPoint(1.5, -0.5),
        CGPoint(1.5, 1),
    ], [
        CGPoint(1.5, 7),
        CGPoint(1.5, 8.5),
    ]]),
    "↓": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(2, 0),
        CGPoint(2, 6),
    ], [
        CGPoint(0, 4),
        CGPoint(2, 6),
        CGPoint(4, 4),
    ]]),
    "→": Letter(style: .Line, size: CGSize(6, defaultSize.height), points: [[
        CGPoint(0, 3),
        CGPoint(6, 3),
    ], [
        CGPoint(4, 1),
        CGPoint(6, 3),
        CGPoint(4, 5),
    ]]),
    "-": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 3),
        CGPoint(4, 3),
    ]]),
    ">": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 3),
        CGPoint(0, 6),
    ]]),
    "<": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(0, 3),
        CGPoint(4, 6),
    ]]),
    "%": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(1, 0),
        CGPoint(1, 1),
        CGPoint(0, 1),
    ], [
        CGPoint(4, 0),
        CGPoint(0, 6),
    ], [
        CGPoint(3, 5),
        CGPoint(4, 5),
        CGPoint(4, 6),
        CGPoint(3, 6),
    ]]),
    "0": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 0),
        CGPoint(4, 6),
        CGPoint(0, 6),
    ], [
        CGPoint(4, 0),
        CGPoint(0, 6),
    ]]),
    "1": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 2),
        CGPoint(2, 0),
        CGPoint(2, 6.25),
    ]]),
    "2": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(0, 5),
        CGPoint(0, 6),
        CGPoint(4, 6),
    ]]),
    "3": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 0),
        CGPoint(1, 3),
        CGPoint(4, 3),
        CGPoint(4, 6),
        CGPoint(0, 6),
    ]]),
    "4": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(3, 0),
        CGPoint(0, 4),
        CGPoint(4, 4),
    ], [
        CGPoint(3, 1),
        CGPoint(3, 6.25),
    ]]),
    "5": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(0, 0),
        CGPoint(0, 3),
        CGPoint(4, 3),
        CGPoint(4, 6),
        CGPoint(0, 6),
    ]]),
    "6": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(0, 6),
        CGPoint(4, 6),
        CGPoint(4, 3),
        CGPoint(3, 3),
    ]]),
    "7": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 0),
        CGPoint(0, 6.25),
    ]]),
    "8": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 0),
        CGPoint(4, 3),
        CGPoint(0, 3),
        CGPoint(0, 6),
        CGPoint(4, 6),
        CGPoint(4, 3),
        CGPoint(0, 3),
    ]]),
    "9": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(3, 3),
        CGPoint(0, 3),
        CGPoint(0, 0),
        CGPoint(4, 0),
        CGPoint(4, 6.25),
    ]]),
    "A": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 6.25),
        CGPoint(0, 1),
        CGPoint(1, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(4, 6.25),
    ], [
        CGPoint(0, 3),
        CGPoint(4, 3),
    ]]),
    "B": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 0),
        CGPoint(3, 1),
        CGPoint(3, 3),
        CGPoint(0, 3),
        CGPoint(4, 3),
        CGPoint(4, 5),
        CGPoint(3, 6),
        CGPoint(0, 6),
    ]]),
    "C": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(1, 0),
        CGPoint(0, 1),
        CGPoint(0, 5),
        CGPoint(1, 6),
        CGPoint(4, 6),
    ]]),
    "D": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(4, 5),
        CGPoint(3, 6),
        CGPoint(0, 6),
    ]]),
    "E": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(0, 0),
        CGPoint(0, 6),
        CGPoint(4, 6),
    ], [
        CGPoint(0, 3),
        CGPoint(3, 3),
    ]]),
    "F": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 6.25),
        CGPoint(0, 0),
        CGPoint(4, 0),
    ], [
        CGPoint(0, 3),
        CGPoint(1.5, 3),
    ]]),
    "G": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(1, 0),
        CGPoint(0, 1),
        CGPoint(0, 5),
        CGPoint(1, 6),
        CGPoint(4, 6),
        CGPoint(4, 3),
        CGPoint(3, 3),
    ]]),
    "H": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, -0.25),
        CGPoint(0, 6.25),
    ], [
        CGPoint(0, 3),
        CGPoint(4, 3),
    ], [
        CGPoint(4, -0.25),
        CGPoint(4, 6.25),
    ]]),
    "I": Letter(style: .Line, size: CGSize(2, defaultSize.height), points: [[
        CGPoint(1, -0.25),
        CGPoint(1, 6.25),
    ]]),
    "J": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, -0.25),
        CGPoint(4, 6),
        CGPoint(1, 6),
        CGPoint(0, 5),
        CGPoint(0, 4),
    ]]),
    "K": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, -0.25),
        CGPoint(0, 6.25),
    ], [
        CGPoint(4, 0),
        CGPoint(0, 3),
        CGPoint(4, 6),
    ]]),
    "L": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, -0.25),
        CGPoint(0, 6),
        CGPoint(4, 6),
    ]]),
    "M": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 6.25),
        CGPoint(0, 0),
        CGPoint(2, 3),
        CGPoint(4, 0),
        CGPoint(4, 6.25),
    ]]),
    "N": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 6.25),
        CGPoint(0, 0),
        CGPoint(4, 6),
        CGPoint(4, -0.25),
    ]]),
    "O": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(1, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(4, 5),
        CGPoint(3, 6),
        CGPoint(1, 6),
        CGPoint(0, 5),
        CGPoint(0, 1),
    ]]),
    "P": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 6.25),
        CGPoint(0, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(4, 2),
        CGPoint(3, 3),
        CGPoint(0, 3),
    ]]),
    "Q": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(1, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(4, 5),
        CGPoint(3, 6),
        CGPoint(1, 6),
        CGPoint(0, 5),
        CGPoint(0, 1),
    ], [
        CGPoint(2, 4),
        CGPoint(3, 6),
    ]]),
    "R": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 6.25),
        CGPoint(0, 0),
        CGPoint(3, 0),
        CGPoint(4, 1),
        CGPoint(4, 2),
        CGPoint(3, 3),
        CGPoint(0.5, 3),
        CGPoint(4, 6.25),
    ]]),
    "S": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(4, 0),
        CGPoint(1, 0),
        CGPoint(0, 1),
        CGPoint(0, 3),
        CGPoint(4, 3),
        CGPoint(4, 5),
        CGPoint(3, 6),
        CGPoint(0, 6),
    ]]),
    "T": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 0),
    ], [
        CGPoint(2, 0),
        CGPoint(2, 6.25),
    ]]),
    "U": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, -0.25),
        CGPoint(0, 5),
        CGPoint(1, 6),
        CGPoint(3, 6),
        CGPoint(4, 5),
        CGPoint(4, -0.25),
    ]]),
    "V": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 6),
        CGPoint(4, 0),
    ]]),
    "W": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(0, 6),
        CGPoint(2, 3),
        CGPoint(4, 6),
        CGPoint(4, 0),
    ]]),
    "X": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 6),
    ], [
        CGPoint(0, 6),
        CGPoint(4, 0),
    ]]),
    "Y": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(2, 3),
        CGPoint(4, 0),
    ], [
        CGPoint(2, 3),
        CGPoint(2, 6.25),
    ]]),
    "Z": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(0, 0),
        CGPoint(4, 0),
        CGPoint(0, 6),
        CGPoint(4, 6),
    ]]),
])
