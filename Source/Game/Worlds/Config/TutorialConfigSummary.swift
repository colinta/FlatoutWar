//
//  TutorialConfigSummary
//  FlatoutWar
//
//  Created by Colin Gray on 1/9/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
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
        ]
    }

}
