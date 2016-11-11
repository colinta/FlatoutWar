////
///  Component.swift
//

@objc
class Component: NSObject, NSCoding {
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

    required init?(coder: NSCoder) {
        super.init()
        enabled = coder.decodeBool(key: "enabled") ?? true
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(enabled, forKey: "enabled")
    }

}

class GrowToComponent: Component {}
