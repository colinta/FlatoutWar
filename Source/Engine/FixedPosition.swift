//
//  FixedPosition.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

enum Position {
    case TL(x: CGFloat, y: CGFloat)
    case T(x: CGFloat, y: CGFloat)
    case TR(x: CGFloat, y: CGFloat)
    case L(x: CGFloat, y: CGFloat)
    case C(x: CGFloat, y: CGFloat)
    case R(x: CGFloat, y: CGFloat)
    case BL(x: CGFloat, y: CGFloat)
    case B(x: CGFloat, y: CGFloat)
    case BR(x: CGFloat, y: CGFloat)

    static func tl(pt: CGPoint) -> Position { return .TL(x: pt.x, y: pt.y) }
    static func t(pt: CGPoint) -> Position { return .T(x: pt.x, y: pt.y) }
    static func tr(pt: CGPoint) -> Position { return .TR(x: pt.x, y: pt.y) }
    static func l(pt: CGPoint) -> Position { return .L(x: pt.x, y: pt.y) }
    static func c(pt: CGPoint) -> Position { return .C(x: pt.x, y: pt.y) }
    static func r(pt: CGPoint) -> Position { return .R(x: pt.x, y: pt.y) }
    static func bl(pt: CGPoint) -> Position { return .BL(x: pt.x, y: pt.y) }
    static func b(pt: CGPoint) -> Position { return .B(x: pt.x, y: pt.y) }
    static func br(pt: CGPoint) -> Position { return .BR(x: pt.x, y: pt.y) }

    func positionIn(size: CGSize) -> CGPoint {
        let half = size / 2
        switch self {
        case let TL(x, y):
            return CGPoint(x: -half.width + x, y: half.height + y)
        case let T(x, y):
            return CGPoint(x: x, y: half.height + y)
        case let TR(x, y):
            return CGPoint(x: half.width + x, y: half.height + y)
        case let L(x, y):
            return CGPoint(x: -half.width + x, y: y)
        case let C(x, y):
            return CGPoint(x: x, y: y)
        case let R(x, y):
            return CGPoint(x: half.width + x, y: y)
        case let BL(x, y):
            return CGPoint(x: -half.width + x, y: -half.height + y)
        case let B(x, y):
            return CGPoint(x: x, y: -half.height + y)
        case let BR(x, y):
            return CGPoint(x: half.width + x, y: -half.height + y)
        }
    }
}
