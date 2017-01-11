////
///  Component.swift
//

@objc
class Component: NSObject {
    var enabled = true
    weak var node: Node!

    func update(_ dt: CGFloat) {
    }

    func reset() {
    }

    override init() {
    }

    func didAddToNode() {
    }

    func removeFromNode() {
        if let node = node {
            node.removeComponent(self)
        }
        reset()
    }

}
