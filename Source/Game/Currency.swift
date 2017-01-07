////
///  Currency.swift
//

struct Currency {
    let experience: Int

    init(experience: Int) {
        self.experience = experience
    }
}

func < (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience < rhs.experience
}

func <= (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience <= rhs.experience
}

func == (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience == rhs.experience
}

func >= (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience >= rhs.experience
}

func > (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience > rhs.experience
}
