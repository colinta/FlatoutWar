//
//  Config.swift
//  FlatoutWar
//
//  Created by Colin Gray on 5/6/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Config {
    var configKey: String { return "Config-\(self.dynamicType)" }
    var Defaults = NSUserDefaults.standardUserDefaults()
}
