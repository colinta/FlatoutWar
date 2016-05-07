//
//  BaseConfigSummary.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class BaseConfigSummary: ConfigSummary {

    override init() {
        super.init()
        configs = [
            BaseLevel1Config(),
            BaseLevel2Config(),
            BaseLevel3Config(),
            BaseLevel4Config(),
            BaseLevel5Config(),
        ]
    }

}
