//
//  ArrayExt.swift
//  FlatoutWar
//
//  Created by Colin Gray on 7/17/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

extension Array {
    func any(@noescape test: (el: Element)->Bool) -> Bool {
        for ob in self {
            if test(el: ob) {
                return true
            }
        }
        return false
    }

    func find(@noescape test: (el: Element)->Bool) -> Element? {
        for ob in self {
            if test(el: ob) {
                return ob
            }
        }
        return nil
    }

    func all(@noescape test: (el: Element)->Bool) -> Bool {
        for ob in self {
            if !test(el: ob) {
                return false
            }
        }
        return true
    }

    func rand() -> Element? {
        guard count > 0 else { return nil }
        let i: Int = Int(arc4random_uniform(UInt32(count)))
        return self[i]
    }
}
