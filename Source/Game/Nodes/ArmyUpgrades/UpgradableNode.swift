////
///  UpgradeableNode.swift
//

protocol UpgradeableNode: class {
    func applyUpgrade(type: UpgradeType)
    func availableUpgrades(world upgradeWorld: World) -> [(ArmyUpgradeButton, UpgradeInfo)]
}

struct UpgradeInfo {
    let title: String
    let upgradeType: UpgradeType
    let description: [String]
    let cost: Currency
    let rate: CGFloat
}
