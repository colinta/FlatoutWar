////
///  CGRectExt.swift
//

public extension CGRect {

// MARK: convenience

    init(x: CGFloat, y: CGFloat, right: CGFloat, bottom: CGFloat) {
        origin = CGPoint(x: x, y: y)
        size = CGSize(width: right - x, height: bottom - y)
    }

    init(size: CGSize) {
        origin = .zero
        self.size = size
    }

    init(centerSize size: CGSize) {
        origin = CGPoint(-size.width / 2, -size.height / 2)
        self.size = size
    }

    init(center: CGPoint, size: CGSize) {
        origin = CGPoint(center.x - size.width / 2, center.y - size.height / 2)
        self.size = size
    }

    init(center: CGPoint, radius: CGFloat) {
        let size = CGSize(r: radius)
        self.init(center: center, size: size)
    }

    static func at(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: 0, height: 0)
    }

// MARK: helpers
    var x: CGFloat { return self.origin.x }
    var y: CGFloat { return self.origin.y }
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

}
