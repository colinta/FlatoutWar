////
///  Sound.swift
//

struct Sound {
    static let PlayerHurt = OpenALManager.sharedInstance().buffer(fromFile: "killed.caf")
    static let PlayerShoot = OpenALManager.sharedInstance().buffer(fromFile: "short.caf")
    static let EnemyHurt = OpenALManager.sharedInstance().buffer(fromFile: "bang.caf")
}
