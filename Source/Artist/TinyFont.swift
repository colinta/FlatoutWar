//
//  TinyFont.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/15/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let defaultSize = CGSize(width: 2, height: 3)
let TinyFont = Font(
    stroke: 0.5,
    scale: 2.5,
    space: 0.75,
    font: [
    "0": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 0, y: 3),
    ], [
        CGPoint(x: 2, y: 0),
        CGPoint(x: 0, y: 3),
    ]]),
    ".": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 1, y: 1),
        CGPoint(x: 1, y: 3),
    ]]),
    "1": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 1),
        CGPoint(x: 1, y: 0),
        CGPoint(x: 1, y: 3.25),
    ]]),
    "2": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 1.5),
        CGPoint(x: 0, y: 1.5),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 2, y: 3),
    ]]),
    "3": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 1, y: 1.5),
        CGPoint(x: 2, y: 1.5),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 0, y: 3),
    ]]),
    "2": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 1.5, y: 0),
        CGPoint(x: 0, y: 2),
        CGPoint(x: 2, y: 2),
    ], [
        CGPoint(x: 1.5, y: 0.5),
        CGPoint(x: 1.5, y: 3.25),
    ]]),
    "5": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 2, y: 0),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 0, y: 1.5),
        CGPoint(x: 2, y: 1.5),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 0, y: 3),
    ]]),
    "6": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 2, y: 0),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 2, y: 1.5),
        CGPoint(x: 1.5, y: 1.5),
    ]]),
    "7": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 0, y: 3.25),
    ]]),
    "8": Letter(style: .Loop, size: defaultSize, points: [[
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 3),
        CGPoint(x: 2, y: 1.5),
        CGPoint(x: 0, y: 1.5),
        CGPoint(x: 0, y: 3),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 1.5),
        CGPoint(x: 0, y: 1.5),
    ]]),
    "9": Letter(style: .Line, size: defaultSize, points: [[
        CGPoint(x: 1.5, y: 1.5),
        CGPoint(x: 0, y: 1.5),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 2, y: 0),
        CGPoint(x: 2, y: 3.25),
    ]]),
])
