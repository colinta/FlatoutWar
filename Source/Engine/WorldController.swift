//
//  WorldController.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/20/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class WorldController: UIViewController {
    var worldView: WorldView?

    override func loadView() {
        let view = WorldView(frame: UIScreen.mainScreen().bounds)
        self.worldView = view
        self.view = worldView

        let Defaults = NSUserDefaults.standardUserDefaults()
        if let hasSeenStartup = Defaults["hasSeenStartup"].bool where hasSeenStartup {
            view.presentWorld(MainMenuWorld())
        }
        else {
            view.presentWorld(StartupWorld())
        }
        // view.presentWorld(Playground())

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
