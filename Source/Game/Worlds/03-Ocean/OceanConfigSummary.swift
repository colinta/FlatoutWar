////
///  OceanConfigSummary.swift
//

class OceanConfigSummary: ConfigSummary {

    override init() {
        super.init()
        configs = [
            OceanLevel1Config(),
            OceanLevel2Config(),
            OceanLevel3Config(),
            OceanLevel4Config(),
            OceanLevel5Config(),
            OceanLevel6Config(),
            OceanLevel7Config(),
            OceanLevel8Config(),
        ]
    }

}
