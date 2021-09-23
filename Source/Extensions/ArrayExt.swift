////
///  ArrayExt.swift
//


extension Sequence {

    func none(_ test: (Iterator.Element) -> Bool) -> Bool {
        return !any(test)
    }

    func any(_ test: (Iterator.Element) -> Bool) -> Bool {
        for ob in self {
            if test(ob) {
                return true
            }
        }
        return false
    }

    func all(_ test: (Iterator.Element) -> Bool) -> Bool {
        for ob in self {
            if !test(ob) {
                return false
            }
        }
        return true
    }

}

extension Array {
    typealias MatcherFn = (Element) -> Bool

    func get(_ index: Int) -> Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : .none
    }

    func zip<T>(_ array: [T]) -> [(Element, T)] {
        var retVal: [(Element, T)] = []
        for (index, item) in array.enumerated() {
            retVal.append((self[index], item))
        }
        return retVal
    }

    func firstMatch(_ test: MatcherFn) -> Element? {
        for ob in self {
            if test(ob) {
                return ob
            }
        }
        return nil
    }

    func lastMatch(_ test: MatcherFn) -> Element? {
        var match: Element?
        for ob in self {
            if test(ob) {
                match = ob
            }
        }
        return match
    }

    func all(_ test: MatcherFn) -> Bool {
        for ob in self {
            if !test(ob) {
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

    mutating func randomPop() -> Element? {
        guard count > 0 else { return nil }
        let i: Int = Int(arc4random_uniform(UInt32(count)))
        return self.remove(at: i)
    }

    func randWeighted(_ weightFn: (Element) -> Float) -> Element? {
        guard count > 0 else { return nil }
        let weights = self.map { weightFn($0) }
        let totalWeight: Float = weights.reduce(0, +)
        var rnd: Float = Float(drand48() * Double(totalWeight))
        for (i, el) in self.enumerated() {
            rnd -= weights[i]
            if rnd < 0 {
                return el
            }
        }
        return nil
    }

}

extension RangeReplaceableCollection {
    mutating func removeMatches(_ test: (Iterator.Element) -> Bool) {
        while let index = self.firstIndex(where: test) {
            remove(at: index)
        }
    }
}

extension RangeReplaceableCollection where Iterator.Element: Equatable {
    mutating func remove(_ item: Iterator.Element) {
        if let index = self.firstIndex(of: item) {
            remove(at: index)
        }
    }

}
