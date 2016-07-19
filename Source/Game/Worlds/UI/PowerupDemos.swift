////
///  UpgradeWorld_PowerupDemos.swift
//

extension Powerup {

    func demo(layer: Node, playerNode: BasePlayerNode, timeline: TimelineComponent) {
        timeline.every(0.5...1) {
            let angle = TAU_8 ± rand(TAU_16)

            let enemyNode = EnemySoldierNode()
            enemyNode.name = "soldier"
            enemyNode.position = playerNode.position + CGPoint(r: 200, a: angle)
            enemyNode.fadeTo(1, start: 0, duration: 0.3)
            layer << enemyNode
        }
    }

}