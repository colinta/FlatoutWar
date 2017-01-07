////
///  RotateScanComponent.swift
//

class RotateScanComponent: ApplyToNodeComponent {
    var rate: CGFloat = 1
    var sweep: CGFloat = TAU_16
    var currentAngle: CGFloat = 0
    private var initialAngle: CGFloat = 0
    private var targetAngle: CGFloat = 0
    private var direction: CGFloat = -1

    override func initApplyTo(node: SKNode) {
        currentAngle = node.zRotation
        initialAngle = node.zRotation
        direction = rand() ? -1 : 1
        targetAngle = currentAngle + sweep / 2 * direction
    }

    func reorient() {
        if let applyTo = applyTo {
            initApplyTo(node: applyTo)
        }
    }

    override func update(_ dt: CGFloat) {
        if let newAngle = moveValue(currentAngle, towards: targetAngle, by: rate * dt) {
            currentAngle = newAngle
        }
        else {
            direction = -direction
            currentAngle = targetAngle
            targetAngle = initialAngle + sweep / 2 * direction
        }

        apply { applyTo in
            applyTo.zRotation = currentAngle
        }
    }

}

extension Node {
    @discardableResult
    func rotateScan(rate: CGFloat? = nil, sweep: CGFloat? = nil) -> RotateScanComponent {
        let rotateScan = get(component: RotateScanComponent.self) ?? RotateScanComponent()
        if let rate = rate {
            rotateScan.rate = rate
        }
        if let sweep = sweep {
            rotateScan.sweep = sweep
        }

        addComponent(rotateScan)

        return rotateScan
    }
}
