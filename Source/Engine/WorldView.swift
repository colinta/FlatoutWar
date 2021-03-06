////
///  WorldView.swift
//

class WorldView: SKView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: BackgroundColor)
        isMultipleTouchEnabled = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            (scene as? WorldScene)?.gameShook()
        }
    }

    func presentWorld(_ world: World) {
        (self.scene as? WorldScene)?.world.reset()
        Artist.clearCache()
        SKTexture.clearCache()
        let scene = WorldScene(size: frame.size, world: world)
        presentScene(scene)
    }
}
