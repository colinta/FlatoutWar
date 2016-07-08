////
///  PauseButton.swift
//

class PauseButton: Button {

    required init() {
        super.init()

        setScale(0.75)
        fixedPosition = .TopRight(x: -20, y: -20)
        text = "||"
        size = CGSize(80)

        touchableComponent?.off(.UpInside)
        touchableComponent?.on(.Down) { _ in
            for handler in self._onTapped {
                handler()
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
