////
///  IconPlayground.swift
//

class IconPlayground: World {

    override func populateWorld() {
        moveCamera(zoom: 2, duration: 0.1)

        let playerNode = BasePlayerNode()
        playerNode.firingComponent?.enabled = false
        playerNode.rotateTo(35.degrees)
        self << playerNode

        do {
            let enemy = EnemySoldierNode()
            enemy.position = CGPoint(x: 40, y: 30)
            enemy.rotateTowards(playerNode)
            enemy.active = false
            self << enemy

            enemy.sprite.lightingBitMask   = 0xFFFFFFFF
            enemy.sprite.shadowCastBitMask = 0xFFFFFFFF
        }

        do {
            let enemy = EnemySoldierNode()
            enemy.position = CGPoint(x: 40, y: 0)
            enemy.rotateTowards(playerNode)
            enemy.active = false
            self << enemy
        }

        // do {
        //     let enemy = EnemyBigJetNode()
        //     enemy.position = CGPoint(x: -25, y: 25)
        //     enemy.rotateTo(-TAU_3_8)
        //     enemy.active = false
        //     self << enemy
        // }

        // do {
        //     let enemy = EnemyJetNode()
        //     enemy.position = CGPoint(x: -17, y: 33)
        //     enemy.rotateTo(-TAU_3_8)
        //     enemy.active = false
        //     self << enemy
        // }

        // do {
        //     let enemy = EnemyJetNode()
        //     enemy.position = CGPoint(x: -11, y: 39)
        //     enemy.rotateTo(-TAU_3_8)
        //     enemy.active = false
        //     self << enemy
        // }
    }

}
