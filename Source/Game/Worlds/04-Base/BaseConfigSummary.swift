////
///  BaseConfigSummary.swift
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
            BaseLevel6Config(),
            BaseLevel7Config(),
            BaseLevel8Config(),
        ]
    }

}
