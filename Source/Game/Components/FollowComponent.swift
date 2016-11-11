////
///  FollowComponent.swift
//

class FollowComponent: Component {
    weak var follow: Node?

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        super.encode(with: encoder)
    }

}
