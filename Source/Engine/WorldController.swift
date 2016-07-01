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

        if Defaults["colin"].bool == true {
            view.presentWorld(TutorialLevel6())
        }
        else if Defaults["hasSeenStartup"].bool == true {
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
