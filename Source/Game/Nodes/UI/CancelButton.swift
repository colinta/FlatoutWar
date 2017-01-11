////
///  CancelButton.swift
//

class CancelButton: Button {

    required init() {
        super.init()
        style = .CircleSized(50)
        setScale(0.5)
        font = .Big
        text = "×"
        size = CGSize(50)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
