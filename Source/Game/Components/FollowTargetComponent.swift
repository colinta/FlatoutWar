////
///  FollowTargetComponent.swift
//

class FollowTargetComponent: FollowComponent {

    override func update(_ dt: CGFloat) {
        guard let follow = follow else { return }

        if let comp = node.rammingComponent {
            comp.tempTarget = follow.position
        }
    }

}
