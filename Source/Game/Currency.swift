////
///  Currency.swift
//

struct Currency {
    let experience: Int
    let resources: Int

    init(experience: Int) { self.init(experience: experience, resources: 0) }
    init(resources: Int) { self.init(experience: 0, resources: resources) }
    init(experience: Int, resources: Int) {
        self.experience = experience
        self.resources = resources
    }
}

func < (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience < rhs.experience && lhs.resources < rhs.resources
}

func <= (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience <= rhs.experience && lhs.resources <= rhs.resources
}

func == (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience == rhs.experience && lhs.resources == rhs.resources
}

func >= (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience >= rhs.experience && lhs.resources >= rhs.resources
}

func > (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.experience > rhs.experience && lhs.resources > rhs.resources
}
