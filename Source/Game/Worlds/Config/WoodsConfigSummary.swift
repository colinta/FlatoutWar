////
///  WoodsConfigSummary.swift
//

class WoodsConfigSummary: ConfigSummary {

    override init() {
        super.init()
        configs = [
            WoodsLevel1Config(),
            WoodsLevel2Config(),
            WoodsLevel3Config(),
            WoodsLevel4Config(),
            WoodsLevel5Config(),
        ]
    }

}
