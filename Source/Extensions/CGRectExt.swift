////
///  CGRectExt.swift
//

extension CGRect {

    init(x: CGFloat, y: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: right - x, height: bottom - y))
    }

    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    init(centerSize size: CGSize) {
        self.init(origin: CGPoint(-size.width / 2, -size.height / 2), size: size)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(center.x - size.width / 2, center.y - size.height / 2), size: size)
    }

    init(center: CGPoint, radius: CGFloat) {
        let size = CGSize(r: radius)
        self.init(center: center, size: size)
    }

    static func at(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: 0, height: 0)
    }

    var x: CGFloat { return self.origin.x }
    var y: CGFloat { return self.origin.y }
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }

}
