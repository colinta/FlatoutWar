////
///  WorldController.swift
//

class WorldController: UIViewController {
    var worldView: WorldView?

    override func loadView() {
        let view = WorldView(frame: UIScreen.mainScreen().bounds)
        self.worldView = view
        self.view = worldView

        if Defaults["colin"].bool == true {
            let world = UpgradeWorld()
            world.nextWorld = BaseLevel1()
            view.presentWorld(Playground())
        }
        else if Defaults["hasSeenStartup"].bool == true {
            view.presentWorld(WorldSelectWorld(beginAt: .Select))
        }
        else {
            view.presentWorld(StartupWorld())
        }

        // view.showsFPS = true
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func halt() {
        (worldView?.scene as? WorldScene)?.world.halt()
    }

    func resume() {
        (worldView?.scene as? WorldScene)?.world.resume()
    }

}
