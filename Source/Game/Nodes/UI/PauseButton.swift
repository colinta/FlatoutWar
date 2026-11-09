////
///  PauseButton.swift
//

class PauseButton: Button {

    required init() {
        super.init()

        setScale(0.75)
        // Leave room for the full hit target, even on displays whose safe area
        // has zero top/side insets (such as Duo's expanded display).
        fixedPosition = .topRight(x: -40, y: -40)
        text = "||"
        size = CGSize(80)

        touchableComponent?.off(.upInside)
        touchableComponent?.on(.down) { _ in
            for handler in self._onTapped {
                handler()
            }
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
