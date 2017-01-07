////
///  BaseLevel.swift
//

class BaseLevel: Level {

    required init() {
        super.init()
        levelSelect = .Base
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func populatePlayerNodes() {
    }

}
