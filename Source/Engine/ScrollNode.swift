////
///  ScrollNode.swift
//

class ScrollNode: Node {
    var fixedX = false
    var fixedY = false
    let content = Node()
    var contentInsets: UIEdgeInsets = .zero

    required init() {
        super.init()

        self << content

        let touchComponent = TouchableComponent()
        touchComponent.on(.Down, onDown)
        touchComponent.onDragged(onDragged)
        touchComponent.on(.Up, onUp)
        addComponent(touchComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func onDown(at location: CGPoint) {
        content.moveToComponent?.removeFromNode()
    }

    func onDragged(from prev: CGPoint, to location: CGPoint) {
        let delta = location - prev
        let dx = fixedX ? 0 : delta.x
        let dy = fixedY ? 0 : delta.y
        content.position = CGPoint(content.position.x + dx, content.position.y + dy)
    }

    func onUp(at location: CGPoint) {
        guard let world = world else { return }

        let contentFrame = content.calculateAccumulatedFrame()

        let maxX = world.size.width / 2 - contentInsets.right
        let minX = -world.size.width / 2 + contentInsets.left
        let maxY = world.size.height / 2 - contentInsets.top
        let minY = -world.size.height / 2 + contentInsets.bottom
        var delta = CGPoint.zero
        if contentFrame.width > world.size.width - contentInsets.left - contentInsets.right {
            if contentFrame.minX > minX {
                delta.x = minX - contentFrame.minX
            }
            else if contentFrame.maxX < maxX {
                delta.x = maxX - contentFrame.maxX
            }
        }
        else {
            if contentFrame.minX < minX {
                delta.x = minX - contentFrame.minX
            }
            else if contentFrame.maxX > maxX {
                delta.x = maxX - contentFrame.maxX
            }
        }

        if contentFrame.height > world.size.height - contentInsets.top - contentInsets.bottom {
            if contentFrame.minY > minY {
                delta.y = minY - contentFrame.minY
            }
            else if contentFrame.maxY < maxY {
                delta.y = maxY - contentFrame.maxY
            }
        }
        else {
            if contentFrame.minY < minY {
                delta.y = minY - contentFrame.minY
            }
            else if contentFrame.maxY > maxY {
                delta.y = maxY - contentFrame.maxY
            }
        }
        let position = content.position + delta
        let roundPos = CGPoint(round(position.x), round(position.y))
        content.moveTo(roundPos, speed: 500)
    }
}
