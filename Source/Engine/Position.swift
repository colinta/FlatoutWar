////
///  Position.swift
//

import CoreGraphics

enum Position {
    case topLeft(x: CGFloat, y: CGFloat)
    case top(x: CGFloat, y: CGFloat)
    case topRight(x: CGFloat, y: CGFloat)
    case left(x: CGFloat, y: CGFloat)
    case center(x: CGFloat, y: CGFloat)
    case right(x: CGFloat, y: CGFloat)
    case bottomLeft(x: CGFloat, y: CGFloat)
    case bottom(x: CGFloat, y: CGFloat)
    case bottomRight(x: CGFloat, y: CGFloat)

    func positionIn(screenSize size: CGSize) -> CGPoint {
        return positionIn(bounds: CGRect(x: -size.width / 2, y: -size.height / 2,
                                         width: size.width, height: size.height))
    }

    // SpriteKit coordinates: the top edge is maxY, not minY.
    func positionIn(bounds: CGRect) -> CGPoint {
        switch self {
        case let .topLeft(x, y):
            return CGPoint(x: bounds.minX + x, y: bounds.maxY + y)
        case let .top(x, y):
            return CGPoint(x: bounds.midX + x, y: bounds.maxY + y)
        case let .topRight(x, y):
            return CGPoint(x: bounds.maxX + x, y: bounds.maxY + y)
        case let .left(x, y):
            return CGPoint(x: bounds.minX + x, y: bounds.midY + y)
        case let .center(x, y):
            return CGPoint(x: bounds.midX + x, y: bounds.midY + y)
        case let .right(x, y):
            return CGPoint(x: bounds.maxX + x, y: bounds.midY + y)
        case let .bottomLeft(x, y):
            return CGPoint(x: bounds.minX + x, y: bounds.minY + y)
        case let .bottom(x, y):
            return CGPoint(x: bounds.midX + x, y: bounds.minY + y)
        case let .bottomRight(x, y):
            return CGPoint(x: bounds.maxX + x, y: bounds.minY + y)
        }
    }

    var x: CGFloat {
        switch self {
        case let .topLeft(x, _):
            return x
        case let .top(x, _):
            return x
        case let .topRight(x, _):
            return x
        case let .left(x, _):
            return x
        case let .center(x, _):
            return x
        case let .right(x, _):
            return x
        case let .bottomLeft(x, _):
            return x
        case let .bottom(x, _):
            return x
        case let .bottomRight(x, _):
            return x
        }
    }

    var y: CGFloat {
        switch self {
        case let .topLeft(_, y):
            return y
        case let .top(_, y):
            return y
        case let .topRight(_, y):
            return y
        case let .left(_, y):
            return y
        case let .center(_, y):
            return y
        case let .right(_, y):
            return y
        case let .bottomLeft(_, y):
            return y
        case let .bottom(_, y):
            return y
        case let .bottomRight(_, y):
            return y
        }
    }
}


func +(lhs: Position, rhs: CGPoint) -> Position {
    switch lhs {
    case let .topLeft(x, y):
        return .topLeft(x: x + rhs.x, y: y + rhs.y)
    case let .top(x, y):
        return .top(x: x + rhs.x, y: y + rhs.y)
    case let .topRight(x, y):
        return .topRight(x: x + rhs.x, y: y + rhs.y)
    case let .left(x, y):
        return .left(x: x + rhs.x, y: y + rhs.y)
    case let .center(x, y):
        return .center(x: x + rhs.x, y: y + rhs.y)
    case let .right(x, y):
        return .right(x: x + rhs.x, y: y + rhs.y)
    case let .bottomLeft(x, y):
        return .bottomLeft(x: x + rhs.x, y: y + rhs.y)
    case let .bottom(x, y):
        return .bottom(x: x + rhs.x, y: y + rhs.y)
    case let .bottomRight(x, y):
        return .bottomRight(x: x + rhs.x, y: y + rhs.y)
    }
}
