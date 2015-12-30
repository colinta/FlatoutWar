//
//  NSCoding.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/21/15.
//  Copyright © 2015 colinta. All rights reserved.
//

public extension NSCoder {

    func decode<T>(key: String) -> T {
        return decodeObjectForKey(key) as! T
    }

    func decodeBool(key: String) -> Bool? {
        if containsValueForKey(key) {
            return decodeBoolForKey(key)
        } else {
            return nil
        }
    }

    func decodeInt(key: String) -> Int? {
        if containsValueForKey(key) {
            return Int(decodeInt64ForKey(key))
        }
        else {
            return nil
        }
    }

    func decodeFloat(key: String) -> Float? {
        if containsValueForKey(key) {
            return decodeFloatForKey(key)
        }
        else {
            return nil
        }
    }

    func decodeCGFloat(key: String) -> CGFloat? {
        if containsValueForKey(key) {
            return CGFloat(decodeFloatForKey(key))
        }
        else {
            return nil
        }
    }

    func decodeSize(key: String) -> CGSize? {
        if containsValueForKey(key) {
            return decodeCGSizeForKey(key)
        } else {
            return nil
        }
    }

    func decodePoint(key: String) -> CGPoint? {
        if containsValueForKey(key) {
            return decodeCGPointForKey(key)
        } else {
            return nil
        }
    }

}

public extension NSCoder {
    func encode(obj: Any?, key: String) {
        if let bool = obj as? Bool {
            encodeBool(bool, forKey: key)
        }
        else if let int = obj as? Int {
            encodeInt64(Int64(int), forKey: key)
        }
        else if let float = obj as? Float {
            encodeFloat(float, forKey: key)
        }
        else if let size = obj as? CGSize {
            encodeCGSize(size, forKey: key)
        }
        else if let point = obj as? CGPoint {
            encodeCGPoint(point, forKey: key)
        }
        else if let obj: AnyObject = obj as? AnyObject {
            encodeObject(obj, forKey: key)
        }
    }
}
