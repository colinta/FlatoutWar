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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
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
