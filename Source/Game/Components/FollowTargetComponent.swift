////
///  FollowTargetComponent.swift
//

class FollowTargetComponent: FollowComponent {

    override func update(dt: CGFloat) {
        guard let follow = follow else { return }

        if let comp = node.rammingComponent {
            comp.tempTarget = follow.position
        }
    }

}
