//
//  AppDelegate.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/20/15.
//  Copyright © 2015 colinta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window = window

        var i = 0
        srand48(time(&i))

        window.makeKeyAndVisible()

        let ctlr = WorldController()
        window.rootViewController = ctlr

        dispatch_async(dispatch_get_main_queue()) {
            self.generateImages()
        }

        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        (window?.rootViewController as? WorldController)?.halt()
    }


    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        (window?.rootViewController as? WorldController)?.resume()
    }

    private func generateImages() {
        let ids: [ImageIdentifier] = [
            .Letter("1", size: .Big),
            .Letter("2", size: .Big),
            .Letter("3", size: .Big),
            .Letter("4", size: .Big),
            .Letter("5", size: .Big),
            .Letter("6", size: .Big),
            .Letter("7", size: .Big),
            .Letter("8", size: .Big),
            .Letter("9", size: .Big),
            .Letter("0", size: .Big),
            .Letter("A", size: .Big),
            .Letter("B", size: .Big),
            .Letter("C", size: .Big),
            .Letter("D", size: .Big),
            .Letter("E", size: .Big),
            .Letter("F", size: .Big),
            .Letter("G", size: .Big),
            .Letter("H", size: .Big),
            .Letter("I", size: .Big),
            .Letter("J", size: .Big),
            .Letter("K", size: .Big),
            .Letter("L", size: .Big),
            .Letter("M", size: .Big),
            .Letter("N", size: .Big),
            .Letter("O", size: .Big),
            .Letter("P", size: .Big),
            .Letter("Q", size: .Big),
            .Letter("R", size: .Big),
            .Letter("S", size: .Big),
            .Letter("T", size: .Big),
            .Letter("U", size: .Big),
            .Letter("V", size: .Big),
            .Letter("W", size: .Big),
            .Letter("X", size: .Big),
            .Letter("Y", size: .Big),
            .Letter("Z", size: .Big),
            .Letter("<", size: .Big),
            .Letter(">", size: .Big),

            .Letter("1", size: .Small),
            .Letter("2", size: .Small),
            .Letter("3", size: .Small),
            .Letter("4", size: .Small),
            .Letter("5", size: .Small),
            .Letter("6", size: .Small),
            .Letter("7", size: .Small),
            .Letter("8", size: .Small),
            .Letter("9", size: .Small),
            .Letter("0", size: .Small),
            .Letter("A", size: .Small),
            .Letter("B", size: .Small),
            .Letter("C", size: .Small),
            .Letter("D", size: .Small),
            .Letter("E", size: .Small),
            .Letter("F", size: .Small),
            .Letter("G", size: .Small),
            .Letter("H", size: .Small),
            .Letter("I", size: .Small),
            .Letter("J", size: .Small),
            .Letter("K", size: .Small),
            .Letter("L", size: .Small),
            .Letter("M", size: .Small),
            .Letter("N", size: .Small),
            .Letter("O", size: .Small),
            .Letter("P", size: .Small),
            .Letter("Q", size: .Small),
            .Letter("R", size: .Small),
            .Letter("S", size: .Small),
            .Letter("T", size: .Small),
            .Letter("U", size: .Small),
            .Letter("V", size: .Small),
            .Letter("W", size: .Small),
            .Letter("X", size: .Small),
            .Letter("Y", size: .Small),
            .Letter("Z", size: .Small),
            .Letter("-", size: .Small),
            .Letter(".", size: .Small),
            .Letter("!", size: .Small),
            .Letter("<", size: .Small),
            .Letter(">", size: .Small),

            .Button(style: .Circle),
            .Button(style: .Square),

            .Enemy(type: .Soldier, health: 100),
            .EnemyShrapnel(type: .Soldier),
            .Enemy(type: .Leader, health: 100),
            .EnemyShrapnel(type: .Leader),
            .Enemy(type: .Scout, health: 100),
            .EnemyShrapnel(type: .Scout),
            .Enemy(type: .Dozer, health: 100),
            .EnemyShrapnel(type: .Dozer),
            .Enemy(type: .GiantSoldier, health: 100),
            .EnemyShrapnel(type: .GiantSoldier),
            .Cursor,
            .Drone(upgrade: FiveUpgrades(1)),
            .Drone(upgrade: FiveUpgrades(2)),
            .Drone(upgrade: FiveUpgrades(3)),
            .Drone(upgrade: FiveUpgrades(4)),
            .Drone(upgrade: FiveUpgrades(5)),
            .Radar(upgrade: FiveUpgrades(1)),
            .Radar(upgrade: FiveUpgrades(2)),
            .Radar(upgrade: FiveUpgrades(3)),
            .Radar(upgrade: FiveUpgrades(4)),
            .Radar(upgrade: FiveUpgrades(5)),
            .BaseSingleTurret(upgrade: FiveUpgrades(1)),
            .BaseSingleTurret(upgrade: FiveUpgrades(2)),
            .BaseSingleTurret(upgrade: FiveUpgrades(3)),
            .BaseSingleTurret(upgrade: FiveUpgrades(4)),
            .BaseSingleTurret(upgrade: FiveUpgrades(5)),
            .BaseTurretBullet(upgrade: FiveUpgrades(1)),
            .BaseTurretBullet(upgrade: FiveUpgrades(2)),
            .BaseTurretBullet(upgrade: FiveUpgrades(3)),
            .BaseTurretBullet(upgrade: FiveUpgrades(4)),
            .BaseTurretBullet(upgrade: FiveUpgrades(5)),
            .BaseDoubleTurret(upgrade: FiveUpgrades(1)),
            .BaseDoubleTurret(upgrade: FiveUpgrades(2)),
            .BaseDoubleTurret(upgrade: FiveUpgrades(3)),
            .BaseDoubleTurret(upgrade: FiveUpgrades(4)),
            .BaseDoubleTurret(upgrade: FiveUpgrades(5)),
            .BaseBigTurret(upgrade: FiveUpgrades(1)),
            .BaseBigTurret(upgrade: FiveUpgrades(2)),
            .BaseBigTurret(upgrade: FiveUpgrades(3)),
            .BaseBigTurret(upgrade: FiveUpgrades(4)),
            .BaseBigTurret(upgrade: FiveUpgrades(5)),
            .Base(upgrade: FiveUpgrades(1), health: 100),
            .Base(upgrade: FiveUpgrades(2), health: 100),
            .Base(upgrade: FiveUpgrades(3), health: 100),
            .Base(upgrade: FiveUpgrades(4), health: 100),
            .Base(upgrade: FiveUpgrades(5), health: 100),
        ]

        for id in ids {
            do {
                Artist.generate(id)
            }
        }
    }

}

