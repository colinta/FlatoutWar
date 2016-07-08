////
///  LetterAndFont.swift
//

struct Letter: Equatable {
    enum Style {
        case Loop
        case Line
    }

    let style: Style
    let size: CGSize
    let points: [[CGPoint]]
}

func ==(lhs: Letter, rhs: Letter) -> Bool {
    if lhs.style == rhs.style && lhs.size == rhs.size && lhs.points.count == rhs.points.count {
        for (index, point) in lhs.points.enumerate() {
            if rhs.points[index] != point {
                return false
            }
        }
        return true
    }
    return false
}

struct Font {
    var stroke: CGFloat
    var scale: CGFloat
    var space: CGFloat
    var size: CGSize
    var art: [String: Letter]
    var height: CGFloat {
        return size.height * scale
    }
    var lineHeight: CGFloat { return height + 8 }
}
