////
///  Config.swift
//

class Config {
    var configKey: String { return "Config-\(type(of: self))" }
    var Defaults = UserDefaults.standard
}
