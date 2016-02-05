//
//  EnemyComponent.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class EnemyComponent: Component {
    private var _targetable: Bool = true
    var targetable: Bool {
        get { return _targetable && enabled }
        set { _targetable = newValue }
    }
    var experience: Int = 0
    weak var intersectionNode: SKNode! {
        didSet {
            if intersectionNode.frame.size == .Zero {
                fatalError("intersectionNodes should not have zero size")
            }
        }
    }

    typealias OnAttacked = (projectile: Node) -> Void
    var _onAttacked: [OnAttacked] = []
    func onAttacked(handler: OnAttacked) { _onAttacked << handler }

    override func reset() {
        super.reset()
        _onAttacked = []
    }

    required override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func attacked(by node: Node) {
        for handler in _onAttacked {
            handler(projectile: node)
        }
    }

}
