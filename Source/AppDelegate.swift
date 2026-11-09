////
///  AppDelegate.swift
//

import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
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
            try AVAudioSession.sharedInstance().setCategory(.ambient)
        }
        catch {}

        var i = 0
        srand48(time(&i))
        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        Artist.clearCache()
        SKTexture.clearCache()
    }
}

// Keep window ownership and gameplay lifecycle tied to the scene, not the app.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = WorldController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        (window?.rootViewController as? WorldController)?.halt()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        (window?.rootViewController as? WorldController)?.resume()
    }
}
