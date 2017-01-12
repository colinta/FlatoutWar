////
///  TutorialConfigSummary
//

class TutorialConfigSummary: ConfigSummary {

    override init() {
        super.init()
        configs = [
            TutorialLevel1Config(),
            TutorialLevel2Config(),
            TutorialLevel3Config(),
            TutorialLevel4Config(),
            TutorialLevel5Config(),
            TutorialLevel6Config(),
            TutorialLevel7Config(),
            TutorialLevel8Config(),
        ]
    }

}
