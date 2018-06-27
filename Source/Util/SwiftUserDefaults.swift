//
// SwiftyUserDefaults
//
// Copyright (c) 2015 Radosław Pietruszewski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import CoreFoundation

extension UserDefaults {
    class Proxy {
        fileprivate let defaults: UserDefaults
        fileprivate let key: String

        fileprivate init(_ defaults: UserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }

        // MARK: Getters

        var object: NSObject? {
            return defaults.object(forKey: key) as? NSObject
        }

        var string: String? {
            return defaults.string(forKey: key)
        }

        var array: [Any]? {
            return defaults.array(forKey: key)
        }

        var dictionary: [String: Any]? {
            return defaults.dictionary(forKey: key)
        }

        var data: Data? {
            return defaults.data(forKey: key)
        }

        var date: NSDate? {
            return object as? NSDate
        }

        var number: NSNumber? {
            return object as? NSNumber
        }

        var int: Int? {
            return number?.intValue
        }

        var double: Double? {
            return number?.doubleValue
        }

        var point: CGPoint? {
            let x = Proxy(defaults, key + ".x").double
            let y = Proxy(defaults, key + ".y").double
            if let x = x, let y = y {
                return CGPoint(x: x, y: y)
            }
            return nil
        }

        var bool: Bool? {
            return number?.boolValue
        }
    }

    /// Returns getter proxy for `key`

    subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }

    /// Sets value for `key`

    subscript(key: String) -> Any? {
        get {
            return self[key]
        }
        set {
            if let v = newValue as? Int {
                set(v, forKey: key)
            } else if let v = newValue as? Double {
                set(v, forKey: key)
            } else if let v = newValue as? CGPoint {
                set(Double(v.x), forKey: key + ".x")
                set(Double(v.y), forKey: key + ".y")
            } else if let v = newValue as? Bool {
                set(v, forKey: key)
            } else if let v = newValue as? NSObject {
                set(v, forKey: key)
            } else if newValue == nil {
                removeObject(forKey: key)
            } else {
                assertionFailure("Invalid value type")
            }
        }
    }

    /// Returns `true` if `key` exists

    func hasKey(_ key: String) -> Bool {
        return object(forKey: key) != nil
    }

    /// Removes value for `key`

    func remove(_ key: String) {
        removeObject(forKey: key)
    }
}

infix operator ?= : AssignmentPrecedence

/// If key doesn't exist, sets its value to `expr`
/// Note: This isn't the same as `Defaults.registerDefaults`. This method saves the new value to disk, whereas `registerDefaults` only modifies the defaults in memory.
/// Note: If key already exists, the expression after ?= isn't evaluated

func ?= (proxy: UserDefaults.Proxy, expr: @autoclosure () -> Any) {
    if !proxy.defaults.hasKey(proxy.key) {
        proxy.defaults[proxy.key] = expr()
    }
}

/// Adds `b` to the key (and saves it as an integer)
/// If key doesn't exist or isn't a number, sets value to `b`

func += (proxy: UserDefaults.Proxy, b: Int) {
    let a = proxy.defaults[proxy.key].int ?? 0
    proxy.defaults[proxy.key] = a + b
}

func += (proxy: UserDefaults.Proxy, b: Double) {
    let a = proxy.defaults[proxy.key].double ?? 0
    proxy.defaults[proxy.key] = a + b
}

/// Icrements key by one (and saves it as an integer)
/// If key doesn't exist or isn't a number, sets value to 1

postfix func ++ (proxy: UserDefaults.Proxy) {
    proxy += 1
}

let Defaults = UserDefaults.standard
