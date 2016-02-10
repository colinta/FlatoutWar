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

    func firstMatch(@noescape test: (el: Element)->Bool) -> Element? {
        for ob in self {
            if test(el: ob) {
                return ob
            }
        }
        return nil
    }

    func lastMatch(@noescape test: (el: Element)->Bool) -> Element? {
        var match: Element?
        for ob in self {
            if test(el: ob) {
                match = ob
            }
        }
        return match
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

    func randWeighted(weightFn: (Element) -> Float) -> Element? {
        guard count > 0 else { return nil }
        let weights = self.map { weightFn($0) }
        let totalWeight: Float = weights.reduce(0, combine: +)
        var rnd: Float = Float(drand48() * Double(totalWeight))
        for (i, el) in self.enumerate() {
            rnd -= weights[i]
            if rnd < 0 {
                return el
            }
        }
        return nil
    }

}

extension RangeReplaceableCollectionType where Generator.Element: Equatable {
    mutating func remove(item: Generator.Element) {
        if let index = self.indexOf(item) {
            removeAtIndex(index)
        }
    }
}
