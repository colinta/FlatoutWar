//
//  AppDelegate.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/20/15.
//  Copyright © 2015 colinta. All rights reserved.
//

import UIKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var device: ALDevice!
    var context: ALContext!
    var soundBuffer: [ALBuffer] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        justOnce("2016-06-30") {
            TutorialConfigSummary().resetAll()
        }

        device = ALDevice(deviceSpecifier: nil)
        context = ALContext(onDevice: device, attributes: nil)
        let manager = OpenALManager.sharedInstance()
        let session = OALAudioSession.sharedInstance()
        manager.currentContext = context

        session.handleInterruptions = true
        session.allowIpod = true
        session.honorSilentSwitch = true

        let mainBundle = NSBundle.mainBundle()
        let sounds = mainBundle.pathsForResourcesOfType("caf", inDirectory: nil)
        for sound in sounds {
            soundBuffer << manager.bufferFromFile(sound)
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        }
        catch {}

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

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        Artist.clearCache()
        SKTexture.clearCache()
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
            .WhiteLetter("1", size: .Big),
            .WhiteLetter("2", size: .Big),
            .WhiteLetter("3", size: .Big),
            .WhiteLetter("4", size: .Big),
            .WhiteLetter("5", size: .Big),
            .WhiteLetter("6", size: .Big),
            .WhiteLetter("7", size: .Big),
            .WhiteLetter("8", size: .Big),
            .WhiteLetter("9", size: .Big),
            .WhiteLetter("0", size: .Big),
            .WhiteLetter("A", size: .Big),
            .WhiteLetter("B", size: .Big),
            .WhiteLetter("C", size: .Big),
            .WhiteLetter("D", size: .Big),
            .WhiteLetter("E", size: .Big),
            .WhiteLetter("F", size: .Big),
            .WhiteLetter("G", size: .Big),
            .WhiteLetter("H", size: .Big),
            .WhiteLetter("I", size: .Big),
            .WhiteLetter("J", size: .Big),
            .WhiteLetter("K", size: .Big),
            .WhiteLetter("L", size: .Big),
            .WhiteLetter("M", size: .Big),
            .WhiteLetter("N", size: .Big),
            .WhiteLetter("O", size: .Big),
            .WhiteLetter("P", size: .Big),
            .WhiteLetter("Q", size: .Big),
            .WhiteLetter("R", size: .Big),
            .WhiteLetter("S", size: .Big),
            .WhiteLetter("T", size: .Big),
            .WhiteLetter("U", size: .Big),
            .WhiteLetter("V", size: .Big),
            .WhiteLetter("W", size: .Big),
            .WhiteLetter("X", size: .Big),
            .WhiteLetter("Y", size: .Big),
            .WhiteLetter("Z", size: .Big),
            .WhiteLetter("<", size: .Big),
            .WhiteLetter(">", size: .Big),

            .WhiteLetter("1", size: .Small),
            .WhiteLetter("2", size: .Small),
            .WhiteLetter("3", size: .Small),
            .WhiteLetter("4", size: .Small),
            .WhiteLetter("5", size: .Small),
            .WhiteLetter("6", size: .Small),
            .WhiteLetter("7", size: .Small),
            .WhiteLetter("8", size: .Small),
            .WhiteLetter("9", size: .Small),
            .WhiteLetter("0", size: .Small),
            .WhiteLetter("A", size: .Small),
            .WhiteLetter("B", size: .Small),
            .WhiteLetter("C", size: .Small),
            .WhiteLetter("D", size: .Small),
            .WhiteLetter("E", size: .Small),
            .WhiteLetter("F", size: .Small),
            .WhiteLetter("G", size: .Small),
            .WhiteLetter("H", size: .Small),
            .WhiteLetter("I", size: .Small),
            .WhiteLetter("J", size: .Small),
            .WhiteLetter("K", size: .Small),
            .WhiteLetter("L", size: .Small),
            .WhiteLetter("M", size: .Small),
            .WhiteLetter("N", size: .Small),
            .WhiteLetter("O", size: .Small),
            .WhiteLetter("P", size: .Small),
            .WhiteLetter("Q", size: .Small),
            .WhiteLetter("R", size: .Small),
            .WhiteLetter("S", size: .Small),
            .WhiteLetter("T", size: .Small),
            .WhiteLetter("U", size: .Small),
            .WhiteLetter("V", size: .Small),
            .WhiteLetter("W", size: .Small),
            .WhiteLetter("X", size: .Small),
            .WhiteLetter("Y", size: .Small),
            .WhiteLetter("Z", size: .Small),
            .WhiteLetter("-", size: .Small),
            .WhiteLetter(".", size: .Small),
            .WhiteLetter("!", size: .Small),
            .WhiteLetter("<", size: .Small),
            .WhiteLetter(">", size: .Small),

            .Button(style: .Circle),
            .Button(style: .CircleSized(70)),
            .Button(style: .Square),

            .Enemy(.Soldier, health: 100),
            .EnemyShrapnel(.Enemy(.Soldier, health: 100), size: .Small),
            .EnemyShrapnel(.Enemy(.Soldier, health: 100), size: .Big),
            .Enemy(.Leader, health: 100),
            .EnemyShrapnel(.Enemy(.Leader, health: 100), size: .Small),
            .EnemyShrapnel(.Enemy(.Leader, health: 100), size: .Big),
            .Enemy(.Scout, health: 100),
            .EnemyShrapnel(.Enemy(.Scout, health: 100), size: .Small),
            .EnemyShrapnel(.Enemy(.Scout, health: 100), size: .Big),
            .Enemy(.Dozer, health: 100),
            .EnemyShrapnel(.Enemy(.Dozer, health: 100), size: .Small),
            .EnemyShrapnel(.Enemy(.Dozer, health: 100), size: .Big),
            .Enemy(.GiantSoldier, health: 100),
            .EnemyShrapnel(.Enemy(.GiantSoldier, health: 100), size: .Small),
            .EnemyShrapnel(.Enemy(.GiantSoldier, health: 100), size: .Big),
            .Cursor,
            .BaseRadar(upgrade: .One),
            .BaseRadar(upgrade: .Two),
            .BaseRadar(upgrade: .Three),
            .BaseRadar(upgrade: .Four),
            .BaseRadar(upgrade: .Five),
            .BaseSingleTurret(upgrade: .One),
            .BaseSingleTurret(upgrade: .Two),
            .BaseSingleTurret(upgrade: .Three),
            .BaseSingleTurret(upgrade: .Four),
            .BaseSingleTurret(upgrade: .Five),
            .BaseRapidTurret(upgrade: .One),
            .BaseRapidTurret(upgrade: .Two),
            .BaseRapidTurret(upgrade: .Three),
            .BaseRapidTurret(upgrade: .Four),
            .BaseRapidTurret(upgrade: .Five),
            .BaseTurretBullet(upgrade: .One, style: .Fast),
            .BaseTurretBullet(upgrade: .Two, style: .Fast),
            .BaseTurretBullet(upgrade: .Three, style: .Fast),
            .BaseTurretBullet(upgrade: .Four, style: .Fast),
            .BaseTurretBullet(upgrade: .Five, style: .Fast),
            .BaseTurretBullet(upgrade: .One, style: .Slow),
            .BaseTurretBullet(upgrade: .Two, style: .Slow),
            .BaseTurretBullet(upgrade: .Three, style: .Slow),
            .BaseTurretBullet(upgrade: .Four, style: .Slow),
            .BaseTurretBullet(upgrade: .Five, style: .Slow),
            .BaseDoubleTurret(upgrade: .One),
            .BaseDoubleTurret(upgrade: .Two),
            .BaseDoubleTurret(upgrade: .Three),
            .BaseDoubleTurret(upgrade: .Four),
            .BaseDoubleTurret(upgrade: .Five),
            .BaseBigTurret(upgrade: .One),
            .BaseBigTurret(upgrade: .Two),
            .BaseBigTurret(upgrade: .Three),
            .BaseBigTurret(upgrade: .Four),
            .BaseBigTurret(upgrade: .Five),
        ]

        for id in ids {
            do {
                Artist.generate(id)
            }
        }
    }

}

