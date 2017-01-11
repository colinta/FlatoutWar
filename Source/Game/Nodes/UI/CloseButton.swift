////
///  CloseButton.swift
//

class CloseButton: Button {

    required init() {
        super.init()
        fixedPosition = .TopRight(x: -15, y: -15)
        setScale(0.5)
        font = .Big
        text = "×"
        size = CGSize(60)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
