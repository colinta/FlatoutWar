////
///  Config.swift
//

class Config {
    var configKey: String { return "Config-\(type(of: self))" }
    fileprivate var Defaults = UserDefaults.standard

    func defaults(_ key: String) -> UserDefaults.Proxy {
        return Defaults["\(configKey)-\(key)"]
    }

    func defaults(has key: String) -> Bool {
        return Defaults.hasKey("\(configKey)-\(key)")
    }

    func defaults(remove key: String) {
        Defaults.remove("\(configKey)-\(key)")
    }

    func defaults(_ key: String, set: Int) {
        Defaults["\(configKey)-\(key)"] = set
    }

    func defaults(_ key: String, set: Bool) {
        Defaults["\(configKey)-\(key)"] = set
    }
}
