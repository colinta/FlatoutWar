////
///  UIColor.swift
//

let WhiteColor = 0xFFFFFF
let BlackColor = 0x0
let NotAllowedColor = 0xCC0A10
let AllowedColor = 0x1EC70B
let BackgroundColor = 0x3F3F3F

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a alpha: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }

    convenience init(hex: Int, alpha: Float = 1.0) {
        self.init(red: hex >> 16 & 0xFF, green: hex >> 8 & 0xFF, blue: hex & 0xFF, a: alpha)
    }
}

extension Int {
    static func rgb(hex: Int) -> (r: Int, g: Int, b: Int) {
        return (
            r: hex >> 16 & 0xFF,
            g: hex >> 8 & 0xFF,
            b: hex & 0xFF
        )
    }

    init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self = red << 16 + green << 8 + blue
    }
}
