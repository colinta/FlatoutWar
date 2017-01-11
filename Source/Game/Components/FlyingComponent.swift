////
///  FlyingComponent.swift
//

class FlyingComponent: PlayerRammingComponent {
    var currentFlyingTarget: CGPoint? { return flyingTargets.first }
    var flyingTargets: [CGPoint] = []
    override var currentTarget: Node? {
        didSet {
            if let currentTarget = currentTarget {
                let nodeAngle = currentTarget.angleTo(node)
                let dist = currentTarget.distanceTo(node)

                let numTargets: Int = Int(dist / 150)
                let segment = dist / CGFloat(numTargets + 1)

                var points: [CGPoint] = []
                for i in 0..<numTargets {
                    let radius = CGFloat(numTargets - i) * segment ± rand(segment / 4)
                    let angle = nodeAngle ± rand(15.degrees)
                    points << (currentTarget.position + CGPoint(r: radius, a: angle))
                }
                flyingTargets = points
            }
            else {
                flyingTargets = []
            }

            if tempTarget == nil {
                tempTarget = flyingTargets.first
            }
        }
    }

    required init() {
        super.init()
    }

    override func removeTempTarget() {
        if let flyingTarget = currentFlyingTarget,
            flyingTarget == tempTarget
        {
            self.flyingTargets.remove(at: 0)
            tempTarget = currentFlyingTarget
        }
        else {
            super.removeTempTarget()
        }
    }

    override func update(_ dt: CGFloat) {
        if let flyingTarget = currentFlyingTarget,
            tempTarget == nil
        {
            self.tempTarget = flyingTarget
        }

        super.update(dt)
    }

}
