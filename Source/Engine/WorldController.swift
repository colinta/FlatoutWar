////
///  WorldController.swift
//

class WorldController: UIViewController {
    var worldView: WorldView?
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func loadView() {
        let view = WorldView(frame: UIScreen.main.bounds)
        self.worldView = view
        self.view = worldView
        if Defaults["colin"].bool == true {
            let world = OceanLevel1()
            view.presentWorld(world)
        }
        else if Defaults["hasSeenStartup"].bool == true {
            view.presentWorld(MainMenuWorld())
        }
        else {
            view.presentWorld(StartupWorld())
        }

        // view.showsFPS = true
    }

    func halt() {
        (worldView?.scene as? WorldScene)?.world.halt()
    }

    func resume() {
        (worldView?.scene as? WorldScene)?.world.resume()
    }

}
