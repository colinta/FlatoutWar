////
///  ScrollNode.swift
//

class ScrollNode: Node {
    var fixedX = false
    var fixedY = false
    let content = Node()
    var contentInsets = UIEdgeInsetsZero

    required init() {
        super.init()

        self << content

        let touchComponent = TouchableComponent()
        touchComponent.on(.Down, onDown)
        touchComponent.onDragged(onDragged)
        touchComponent.on(.Up, onUp)
        addComponent(touchComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onDown(location: CGPoint) {
        content.moveToComponent?.removeFromNode()
    }

    func onDragged(prev: CGPoint, location: CGPoint) {
        let delta = location - prev
        let dx = fixedX ? 0 : delta.x
        let dy = fixedY ? 0 : delta.y
        content.position = CGPoint(content.position.x + dx, content.position.y + dy)
    }

    func onUp(location: CGPoint) {
        guard let world = world else { return }

        let frame = calculateAccumulatedFrame()

        let maxX = world.size.width / 2
        let minX = -world.size.width / 2
        let maxY = world.size.height / 2 - contentInsets.top
        let minY = -world.size.height / 2 + contentInsets.bottom
        var delta = CGPoint.zero
        if frame.width > world.size.width {
            if frame.minX > minX {
                delta.x = minX - frame.minX
            }
            else if frame.maxX < maxX {
                delta.x = maxX - frame.maxX
            }
        }
        else {
            if frame.minX < minX {
                delta.x = minX - frame.minX
            }
            else if frame.maxX > maxX {
                delta.x = maxX - frame.maxX
            }
        }

        if frame.height > world.size.height {
            if frame.minY > minY {
                delta.y = minY - frame.minY
            }
            else if frame.maxY < maxY {
                delta.y = maxY - frame.maxY
            }
        }
        else {
            if frame.minY < minY {
                delta.y = minY - frame.minY
            }
            else if frame.maxY > maxY {
                delta.y = maxY - frame.maxY
            }
        }
        let position = content.position + delta
        let roundPos = CGPoint(round(position.x), round(position.y))
        content.moveTo(roundPos, speed: 500)
    }
}
