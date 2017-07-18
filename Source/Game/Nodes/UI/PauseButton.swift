////
///  PauseButton.swift
//

class PauseButton: Button {

    required init() {
        super.init()

        setScale(0.75)
        fixedPosition = .topRight(x: -20, y: -20)
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
