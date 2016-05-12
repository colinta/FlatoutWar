//
//  ResourceTutorial.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class ResourceTutorial: Tutorial {
    var firstResource = ResourceNode()
    let dragIndicator: Node = {
        let n = Node()
        n << SKSpriteNode(id: .ColorCircle(size: CGSize(60), color: 0xFFFFFF))
        return n
    }()

    override func populateWorld() {
        super.populateWorld()

        dragIndicator.alpha = 0
        dragIndicator.position = playerNode.position
        tutorialTextNode.text = "RESOURCES"

        timeline.at(1) {
            self.showFirstResource()
        }
    }

    func showFirstResource() {
        let arcTo = firstResource.arcTo(
            CGPoint(x: 0, y: -100),
            control: CGPoint(x: 200, y: -100),
            start: CGPoint(x: 200, y: 100),
            duration: 5)
        arcTo.rotate = false
        firstResource.keepRotating()
        self << firstResource

        timeline.after(1) {
            self.showFirstDrag()
        }

        timeline.after(3) {
            var distOffset: CGFloat = 0
            100.times { (i: Int) in
                let soldier = EnemySoldierNode()
                soldier.position = CGPoint(r: self.size.width / 2 + distOffset, a: 0)
                self << soldier
                distOffset += soldier.size.width + 4
            }
        }
    }

    func showFirstDrag() {
        dragIndicator.fadeTo(1, start: 0, duration: 0.3)
        dragIndicator.moveTo(firstResource.position, speed: 100, removeComponent: false).onArrived {
            self.dragIndicator.position = self.playerNode.position
        }
        self << dragIndicator
    }

    override func update(dt: CGFloat) {
        dragIndicator.moveToComponent?.target = firstResource.position
    }

    func done() {
        tutorialTextNode.text = "YOU GOT THIS!"

        addContinueButton()
    }

}
