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
        let view = WorldView(frame: .zero)
        self.worldView = view
        self.view = view
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let view = worldView, view.bounds.width > 0, view.bounds.height > 0,
              view.scene == nil else { return }

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
