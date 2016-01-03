//
//  Tutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/2/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class Tutorial: World {
    let tutorialTextNode = TextNode(at: CGPoint(x: 50, y: 40))
    let playerNode = BasePlayerNode()

    required init() {
        super.init()
        pauseable = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func populateWorld() {
        setScale(1.5)
        cameraNode = Node(at: CGPoint(x: 80, y: -40))

        tutorialTextNode.font = .Small
        self << tutorialTextNode

        playerNode.touchableComponent?.enabled = false
        playerNode.touchableComponent?.enabled = false
        self << playerNode
    }

}
