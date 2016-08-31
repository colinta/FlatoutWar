////
///  UpgradeableNodes.swift
//

protocol UpgradeableNodes: class {
    func availableUpgrades(world upgradeWorld: UpgradeWorld) -> [Button]
}
