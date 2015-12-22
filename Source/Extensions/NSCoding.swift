//
//  NSCoding.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/15.
//  Copyright © 2015 colinta. All rights reserved.
//

public class Coder {
    public let coder: NSCoder

    public init(_ coder: NSCoder) {
        self.coder = coder
    }
}

public extension Coder {

    subscript(key: String) -> AnyObject? {
        get { return coder.decodeObjectForKey(key) }
        set {
            coder.encodeObject(newValue, forKey: key)
        }
    }

    func decodeKey<T>(key: String) -> T {
        return coder.decodeObjectForKey(key) as! T
    }

    func decodeKey(key: String) -> Bool {
        if coder.containsValueForKey(key) {
            return coder.decodeBoolForKey(key)
        } else {
            return false
        }
    }

    func decodeKey(key: String) -> Int {
        return Int(coder.decodeInt64ForKey(key))
    }
}

public extension Coder {
    func decodeOptionalKey<T>(key: String) -> T? {
        if coder.containsValueForKey(key) {
            return coder.decodeObjectForKey(key) as? T
        } else {
            return .None
        }
    }

    func decodeOptionalKey(key: String) -> Bool? {
        if coder.containsValueForKey(key) {
            return coder.decodeBoolForKey(key)
        } else {
            return .None
        }
    }

    func decodeOptionalKey(key: String) -> Int? {
        if coder.containsValueForKey(key) {
            return Int(coder.decodeInt64ForKey(key))
        } else {
            return .None
        }
    }
}

public extension Coder {
    func encodeObject(obj: Any?, forKey key: String) {
        if let bool = obj as? Bool {
            coder.encodeBool(bool, forKey: key)
        }
        else if let int = obj as? Int {
            coder.encodeInt64(Int64(int), forKey: key)
        }
        else if let obj: AnyObject = obj as? AnyObject {
            coder.encodeObject(obj, forKey: key)
        }
    }
}
