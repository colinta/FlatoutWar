//
//  Node.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Node: SKNode {
    var components: [Component] = []

    convenience init(at point: CGPoint) {
        self.init()
        position = point
    }

    required override init() {
        super.init()
        populate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addComponent(component: Component) {
        components << component
    }

    func removeComponent(component: Component) {
        if let index = components.indexOf(component) {
            components.removeAtIndex(index)
        }
    }

    func populate() {
    }

    func reset() {
    }

    func update(dt: CGFloat) {
    }

    func updateNodes(dt: CGFloat) {
        for component in components {
            component.update(dt, node: self)
        }
        update(dt)
        for sknode in children {
            if let node = sknode as? Node {
                node.updateNodes(dt)
            }
        }
    }

}
