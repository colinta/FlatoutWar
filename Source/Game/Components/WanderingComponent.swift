////
///  WanderingComponent.swift
//

class WanderingComponent: Component {
    private var _adjustingPosition = false
    private var _centeredAround: CGPoint?

    var centeredAround: CGPoint? {
        get { return _centeredAround }
        set {
            if !_adjustingPosition {
                _centeredAround = newValue
                if let currentTargetLocation = currentTargetLocation,
                    !node.position.distanceTo(currentTargetLocation, within: wanderingRadius)
                {
                    self.currentTargetLocation = nil
                }
            }
        }
    }
    var wanderingRadius: CGFloat = 20
    var acceleration: CGFloat = 3
    var maxSpeed: CGFloat = 4
    var maxTurningSpeed: CGFloat = 3.5

    convenience init(centeredAround: CGPoint) {
        self.init()
        self.centeredAround = centeredAround
    }

    private var currentSpeed: CGFloat = 0
    private var currentTargetLocation: CGPoint?
    private var wanderingTimeLimit: CGFloat = 0
    private var currentWanderingTime: CGFloat = 0

    override func update(_ dt: CGFloat) {
        let currentTargetLocation: CGPoint
        if let loc = self.currentTargetLocation {
            currentTargetLocation = loc
        }
        else {
            if let centeredAround = centeredAround {
                currentTargetLocation = centeredAround + CGPoint(r: rand(min: wanderingRadius / 2, max: wanderingRadius), a: rand(TAU))
            }
            else {
                currentTargetLocation = node.position + CGPoint(r: rand(min: wanderingRadius / 2, max: wanderingRadius), a: rand(TAU))
            }
            self.currentTargetLocation = currentTargetLocation
            wanderingTimeLimit = 1.5 * currentTargetLocation.distanceTo(node.position) / self.maxSpeed
            currentWanderingTime = 0
        }

        var currentMaxSpeed = self.maxSpeed
        if let rotateToComponent = node.rotateToComponent {
            rotateToComponent.target = node.position.angleTo(currentTargetLocation)
            if rotateToComponent.isRotating && currentMaxSpeed > maxTurningSpeed {
                currentMaxSpeed = maxTurningSpeed
            }
        }

        currentSpeed = moveValue(currentSpeed, towards: currentMaxSpeed, by: dt * acceleration) ?? currentSpeed

        let nodeAngle: CGFloat
        if node.rotateToComponent != nil {
            nodeAngle = node.zRotation
        }
        else {
            nodeAngle = node.position.angleTo(currentTargetLocation)
        }

        let vector = currentSpeed * CGPoint(r: dt, a: nodeAngle)
        let newPosition = node.position + vector

        _adjustingPosition = true
        node.position = newPosition
        _adjustingPosition = false

        currentWanderingTime += dt

        if newPosition.distanceTo(currentTargetLocation, within: 1) {
            self.currentTargetLocation = nil
        }
        // guard against nodes that cannot reach their destination (due to
        // rotating endlessly around the destination)
        else if currentWanderingTime > wanderingTimeLimit {
            self.currentTargetLocation = nil
        }
    }

}
