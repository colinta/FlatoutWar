//
//  Component.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class Component {
    var enabled = true

    func update(dt: CGFloat, node: Node) {
    }

    func reset() {
    }

}


extension Component: Equatable {}
func ==(lhs: Component, rhs: Component) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
