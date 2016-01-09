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

        view.presentWorld(BaseLevel3())
        // view.presentWorld({
        //     let world = BaseUpgradeWorld()
        //     let level = BaseLevel4()
        //     level.config.storedPlayers = [
        //         DroneNode(at: CGPoint(-100, 40)),
        //     ]
        //     world.nextWorld = level
        //     return world
        // }())

        view.showsFPS = true
        view.showsNodeCount = true
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
