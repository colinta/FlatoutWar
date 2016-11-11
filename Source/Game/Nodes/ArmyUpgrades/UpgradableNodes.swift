////
///  UpgradeableNodes.swift
//

protocol UpgradeableNodes: class {
    func availableUpgrades(world upgradeWorld: World) -> [(Button, String)]
}
