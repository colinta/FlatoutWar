////
///  Button.swift
//

let ButtonScale: CGFloat = 1.1
let ButtonDisabledAlpha: CGFloat = 0.25

enum ButtonStyle {
    case Square
    case SquareSized(Int)
    case RectSized(Int, Int)
    case RectToFit
    case Circle
    case CircleSized(Int)
    case None

    var size: CGSize {
        switch self {
        case .Square: return CGSize(50)
        case .Circle: return CGSize(60)
        case let .SquareSized(size): return CGSize(CGFloat(size))
        case let .RectSized(width, height): return CGSize(CGFloat(width), CGFloat(height))
        case let .CircleSized(size): return CGSize(CGFloat(size))
        default: return .zero
        }
    }

    var margins: UIEdgeInsets {
        switch self {
        case .RectToFit: return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        default: return .zero
        }
    }

}

class Button: TextNode {
    enum ButtonBehavior {
        case Disable
    }

    var style: ButtonStyle = .None {
        didSet { updateButtonStyle() }
    }
    var preferredScale: CGFloat = 1
    var background: Int? = nil {
        didSet { updateButtonStyle() }
    }
    var border: Int? {
        didSet { updateButtonStyle() }
    }

    private var prevZ: CGFloat = 0

    private var buttonStyleNode: SKSpriteNode!
    private var buttonBackgroundNode: SKSpriteNode!
    private var alphaOverride = true
    override var alpha: CGFloat {
        didSet {
            alphaOverride = false
        }
    }
    var enabled = true {
        didSet {
            if alphaOverride {
                alpha = enabled ? 1 : ButtonDisabledAlpha  // sets alphaOverride to false
                alphaOverride = true
            }
            touchableComponent?.enabled = enabled
        }
    }

    func onTapped(_ behavior: ButtonBehavior) -> Self {
        onTapped {
            switch behavior {
            case .Disable:
                self.touchableComponent?.enabled = false
            }
        }
        return self
    }

    typealias OnTapped = Block
    var _onTapped: [OnTapped] = []
    func onTapped(_ handler: @escaping OnTapped) { _onTapped.append(handler) }
    func offTapped() { _onTapped = [] }
    func triggerTapped() {
        for handler in self._onTapped {
            handler()
        }
    }

    override func setScale(_ scale: CGFloat) {
        preferredScale = scale
        super.setScale(scale)
    }

    override func calculateMargins() -> UIEdgeInsets {
        let margins = super.calculateMargins()
        let styleMargins = style.margins
        return UIEdgeInsets(
            top: margins.top + styleMargins.top,
            left: margins.left + styleMargins.left,
            bottom: margins.bottom + styleMargins.bottom,
            right: margins.right + styleMargins.right
            )
    }

    override func reset() {
        super.reset()
        _onTapped = []
    }

    required init() {
        buttonStyleNode = SKSpriteNode(id: .None)
        buttonBackgroundNode = SKSpriteNode(id: .None)

        super.init()

        buttonStyleNode.z = .Bottom
        self << buttonStyleNode

        buttonBackgroundNode.z = .Bottom
        self << buttonBackgroundNode

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = { [unowned self] (_, location) in
            return self.containsTouchTest(at: location)
        }
        touchableComponent.on(.Enter) { _ in
            self.highlight()
        }
        touchableComponent.on(.Exit) { _ in
            self.unhighlight()
        }
        touchableComponent.on(.UpInside) { _ in self.triggerTapped() }
        addComponent(touchableComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateTextNodes() {
        super.updateTextNodes()
        updateButtonStyle()
    }

    func containsTouchTest(at location: CGPoint) -> Bool {
        let width = max(44, size.width)
        let height = max(44, size.height)

        var minX: CGFloat, maxX: CGFloat
        var minY = -height / 2
        var maxY = height / 2

        switch alignment {
        case .left:
            minX = 0
            maxX = width
        case .right:
            minX = -width
            maxX = 0
        default:
            minX = -width / 2
            maxX = width / 2
        }

        let margins = calculateMargins()
        minX -= margins.left
        maxX += margins.right
        minY -= margins.bottom
        maxY += margins.top

        return location.x >= minX && location.x <= maxX && abs(location.y) <= height / 2
    }

    private func updateButtonStyle() {
        var textureStyle = style

        switch style {
        case .None:
            break
        case .RectToFit:
            let rectMargin: CGFloat = 10
            size = CGSize(CGFloat(ceil(textSize.width)) + rectMargin, CGFloat(ceil(textSize.height)) + rectMargin)
            let margins = calculateMargins()
            size.width += margins.left + margins.right
            size.height += margins.top + margins.bottom
            textureStyle = .RectSized(Int(size.width), Int(size.height))
        default:
            size = style.size
        }
        buttonStyleNode.textureId(.Button(style: textureStyle, color: border ?? color))

        var backgroundId: ImageIdentifier = .None
        if let background = background {
            switch style {
            case .None: break
            case .Circle, .CircleSized:
                backgroundId = .FillColorCircle(size: size, color: background)
            default:
                backgroundId = .FillColorBox(size: size, color: background)
            }
        }
        buttonBackgroundNode.textureId(backgroundId)

        switch alignment {
        case .left:
            buttonStyleNode.anchorPoint = CGPoint(0, 0.5)
            buttonBackgroundNode.anchorPoint = CGPoint(0, 0.5)
        case .right:
            buttonStyleNode.anchorPoint = CGPoint(1, 0.5)
            buttonBackgroundNode.anchorPoint = CGPoint(1, 0.5)
        default:
            buttonStyleNode.anchorPoint = CGPoint(0.5, 0.5)
            buttonBackgroundNode.anchorPoint = CGPoint(0.5, 0.5)
        }
    }

    func highlight() {
        prevZ = zPosition
        z = .Top
        super.setScale(preferredScale * ButtonScale)
    }

    func unhighlight() {
        zPosition = prevZ
        super.setScale(preferredScale)
    }

}
