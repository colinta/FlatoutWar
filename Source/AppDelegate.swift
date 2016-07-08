////
///  AppDelegate.swift
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
        justOnce("2016-07-07") {
            TutorialConfigSummary().completeAll()
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

}

