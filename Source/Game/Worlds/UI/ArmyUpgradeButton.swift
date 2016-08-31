////
///  ArmyUpgradeButton.swift
//

class ArmyUpgradeButton: Button {
    var icon: SKSpriteNode?

    let node: Node
    // {
    //     willSet {
    //         if node != newValue {
    //             node.removeFromParent()
    //         }
    //     }
    //     didSet {
    //         if node != oldValue {
    //             self << node
    //         }
    //     }
    // }

    required init(node: Node) {
        self.node = node
        super.init()
        style = .Circle
        node.position = .zero
        node.touchableComponent?.enabled = false
        self << node
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
