////
///  BaseLevel2.swift
//

class BaseLevel2: BaseLevel {

    override func loadConfig() -> BaseConfig { return BaseLevel2Config() }

    override func populateLevel() {
        beginWave1()
    }

    func beginWave1() {
        let nextStep = afterN {
            self.onNoMoreEnemies { self.beginWave2() }
        }

        let da: CGFloat = 5.degrees
        timeline.every(4.5...7, times: 8) {
            let angle = self.randSideAngle()
            self.generateWarning(angle)
            self.timeline.at(.Delayed()) {
                self.generateLeaderEnemy(angle, spread: 0, constRadius: true)()
                3.times { (i: Int) in
                    self.generateScouts(angle + da * CGFloat(i - 1), spread: 0, constRadius: true)()
                }
            }
        } ~~> nextStep()
    }

    func beginWave2() {
        10.times { (i: Int) in
            generateWarning(TAU * CGFloat(i) / 10)
        }

        timeline.every(4.5, start: .Delayed(), times: 11) {
            self.generateScouts(rand(TAU))()
        }
        timeline.every(3.5, start: .Delayed(1), times: 14) {
            self.generateEnemy(rand(TAU))()
        }
        timeline.every(7, start: .Delayed(3), times: 7) {
            self.generateSlowEnemy(rand(TAU))()
        }
    }

}
