////
///  WorldView.swift
//

class WorldView: SKView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: BackgroundColor)
        multipleTouchEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            (scene as? WorldScene)?.gameShook()
        }
    }

    func presentWorld(world: World) {
        (self.scene as? WorldScene)?.world.reset()
        Artist.clearCache()
        SKTexture.clearCache()
        let scene = WorldScene(size: frame.size, world: world)
        presentScene(scene)
    }
}
