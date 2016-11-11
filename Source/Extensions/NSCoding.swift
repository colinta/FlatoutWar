////
///  NSCoding.swift
//

public extension NSCoder {

    func decode<T>(key: String) -> T {
        return decodeObject(forKey: key) as! T
    }

    func decodeBool(key: String) -> Bool? {
        if containsValue(forKey: key) {
            return decodeBool(forKey: key)
        } else {
            return nil
        }
    }

    func decodeInt(key: String) -> Int? {
        if containsValue(forKey: key) {
            return Int(decodeInt64(forKey: key))
        }
        else {
            return nil
        }
    }

    func decodeFloat(key: String) -> Float? {
        if containsValue(forKey: key) {
            return decodeFloat(forKey: key)
        }
        else {
            return nil
        }
    }

    func decodeCGFloat(key: String) -> CGFloat? {
        if containsValue(forKey: key) {
            return CGFloat(decodeFloat(forKey: key))
        }
        else {
            return nil
        }
    }

    func decodeSize(key: String) -> CGSize? {
        if containsValue(forKey: key) {
            return decodeCGSize(forKey: key)
        } else {
            return nil
        }
    }

    func decodePoint(key: String) -> CGPoint? {
        if containsValue(forKey: key) {
            return decodeCGPoint(forKey: key)
        } else {
            return nil
        }
    }

}
