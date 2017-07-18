////
///  Artist.swift
//

private var generatedImages: [String: UIImage] = [:]

class Artist {
    static func clearCache() {
        generatedImages = [:]
    }

    static func saveCache() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        for (name, image) in generatedImages {
            let data = UIImagePNGRepresentation(image)
            let filename = "\(name.replacingOccurrences(of: ":", with: ";")).png"
            if let data = data, let path = NSURL(fileURLWithPath: documents).appendingPathComponent(filename) {
                try! data.write(to: path, options: [.atomicWrite])
            }
        }
    }

    enum Scale {
        case small
        case normal
        case zoomed

        static var `default`: Scale {
            if UIDevice.current.userInterfaceIdiom == .pad ||
                UIScreen.main.scale == 3
            {
                return .zoomed
            }
            return .normal
        }

        var drawScale: CGFloat {
            switch self {
            case .small: return 1
            case .normal: return 2
            case .zoomed: return 3
            }
        }

        var suffix: String {
            switch self {
            case .normal: return "@2x"
            case .zoomed: return "@3x"
            default:
                return ""
            }
        }
    }

    var center: CGPoint = .zero
    private(set) var middle: CGPoint = .zero
    var size: CGSize = .zero {
        didSet {
            middle = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }
    var scale: Scale = .small

    enum Shadowed {
        case `false`
        case `true`
        case size(CGFloat)
    }

    var shadowed = Shadowed.false

    required init() {
    }

    func generate(in context: CGContext) {
        context.saveGState()
        context.scaleBy(x: scale.drawScale, y: scale.drawScale)

        let offset = drawingOffset()
        context.translateBy(x: offset.x, y: offset.y)

        draw(in: context)
        context.restoreGState()
    }

    func rotate(context: CGContext, angle: CGFloat) {
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.rotate(by: angle)
        context.translateBy(x: -size.width / 2, y: -size.height / 2)
    }

    func draw(in context: CGContext) {
    }

    func drawingOffset() -> CGPoint {
        if shadowed.boolValue {
            let shadowSize = shadowed.floatValue
            switch scale {
            case .small:
                return CGPoint(shadowSize - 1)
            case .normal:
                return CGPoint(shadowSize)
            case .zoomed:
                return CGPoint(shadowSize - 2)
            }
        }
        else {
            return CGPoint(1)
        }
    }

    func imageSize() -> CGSize {
        var size = self.size
        let offset = drawingOffset()
        size += CGSize(
            width: offset.x * 2,
            height: offset.y * 2
        )
        size.width = max(size.width, 1)
        size.height = max(size.height, 1)
        return size
    }
}

extension Artist.Shadowed {
    var boolValue: Bool {
        return floatValue > 0
    }
    var floatValue: CGFloat {
        switch self {
        case .false: return 0
        case .true: return 5
        case let .size(size): return size
        }
    }
}

extension Artist {
    class func generate(_ id: ImageIdentifier, scale: Scale = .default) -> UIImage {
        var cacheName: String?
        if let name = id.name {
            cacheName = "\(name)\(scale.suffix)"
            if let cached = generatedImages[cacheName!] {
                return cached
            }
        }

        let artist = id.artist
        artist.scale = scale
        let size = artist.imageSize() * scale.drawScale

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        artist.generate(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let cacheName = cacheName {
            generatedImages[cacheName] = image
        }
        return image!
    }
}
