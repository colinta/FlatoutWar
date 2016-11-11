////
///  AppDelegate.swift
//

import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var device: ALDevice!
    var context: ALContext!
    var soundBuffer: [ALBuffer] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        justOnce("2016-07-07") {
            TutorialConfigSummary().completeAll()
        }
        justOnce("2016-07-13") {
            BaseLevel1Config().storedPowerups = [
                (GrenadePowerup(count: 2), 0),
                (LaserPowerup(count: 1), 1),
                (MinesPowerup(count: 2), 2),
                (HourglassPowerup(count: 0), nil),
            ]
        }
        justOnce("2016-08-17") {
            if BaseLevel1Config().storedPlayers.isEmpty {
                BaseLevel1Config().storedPlayers = [BasePlayerNode(), DroneNode(at: CGPoint(x: 80))]
            }
            if TutorialLevel6Config().storedPlayers.isEmpty {
                TutorialLevel6Config().storedPlayers = [BasePlayerNode(), DroneNode(at: CGPoint(x: 80))]
            }
        }

        let upgradeConfig = UpgradeConfigSummary()
        print("spent: (\(upgradeConfig.spentExperience), \(upgradeConfig.spentResources))")
        print("storedPowerups:")
        for entry in BaseLevel1Config().storedPowerups {
            let orderStr: String
            if let order = entry.order { orderStr = "\(order)" }
            else { orderStr = "--" }
            print("- \(type(of: entry.powerup)) count: \(entry.powerup.count), order: \(orderStr)")
        }
        upgradeConfig.spentExperience = 0
        upgradeConfig.spentResources = 0
        BaseLevel1Config().storedPowerups = [
            (GrenadePowerup(count: 2), 0),
            (LaserPowerup(count: 1), 1),
            (MinesPowerup(count: 2), 2),
            (HourglassPowerup(count: 0), nil),
        ]

        device = ALDevice(deviceSpecifier: nil)
        context = ALContext(on: device, attributes: nil)
        if let manager = OpenALManager.sharedInstance() {
            manager.currentContext = context

            let sounds = Bundle.main.paths(forResourcesOfType: "caf", inDirectory: nil)
            for sound in sounds {
                if let sound = manager.buffer(fromFile: sound) {
                    soundBuffer << sound
                }
            }
        }

        if let session = OALAudioSession.sharedInstance() {
            session.handleInterruptions = true
            session.allowIpod = true
            session.honorSilentSwitch = true
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        }
        catch {}

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        var i = 0
        srand48(time(&i))

        window.makeKeyAndVisible()

        let ctlr = WorldController()
        window.rootViewController = ctlr

        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        Artist.clearCache()
        SKTexture.clearCache()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        (window?.rootViewController as? WorldController)?.halt()
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        (window?.rootViewController as? WorldController)?.resume()
    }

}

