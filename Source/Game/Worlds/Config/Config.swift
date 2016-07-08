////
///  Config.swift
//

class Config {
    var configKey: String { return "Config-\(self.dynamicType)" }
    var Defaults = NSUserDefaults.standardUserDefaults()
}
