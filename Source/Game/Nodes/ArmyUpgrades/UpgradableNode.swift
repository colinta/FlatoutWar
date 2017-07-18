////
///  UpgradeableNode.swift
//

protocol UpgradeableNode: class {
    func upgradeTitle() -> String
    func applyUpgrade(type: UpgradeType)
}

enum UpgradeType {
    case radarUpgrade
    case bulletUpgrade
    case movementUpgrade
}

struct UpgradeInfo {
    let title: String
    let upgradeType: UpgradeType
    let description: [String]
    let cost: Currency
    let rate: CGFloat
}
