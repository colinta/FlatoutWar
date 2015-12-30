//
//  DroneNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/22/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

class DroneNode: Node {
    var cursor = CursorNode()
    var sprite = SKSpriteNode(id: .Drone(upgrade: .One))
    var placeholder = SKSpriteNode(id: .Drone(upgrade: .One))

    required init() {
        super.init()
        size = sprite.size

        cursor.visible = false
        self << cursor

        placeholder.alpha = 0.5
        placeholder.hidden = false
        self << placeholder

        let touchableComponent = TouchableComponent()
        touchableComponent.containsTouchTest = TouchableComponent.defaultTouchTest(.Square)
        touchableComponent.shouldAcceptTouchTest = touchableComponent.containsTouchTest
        addComponent(touchableComponent)

        let selectableComponent = SelectableComponent()
        selectableComponent.bindTo(touchableComponent: touchableComponent)
        selectableComponent.onSelected(onSelected)
        addComponent(selectableComponent)

        let draggingComponent = DraggableComponent()
        draggingComponent.placeholder = placeholder
        draggingComponent.bindTo(touchableComponent: touchableComponent)
        draggingComponent.onDragMove { isMoving in
            self.alpha = isMoving ? 0.5 : 1
            self.enabled = !isMoving
            self.world?.unselectNode(self)
        }
        addComponent(draggingComponent)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        touchableComponent?.containsTouchTest = TouchableComponent.defaultTouchTest(.Square)
        cursor = coder.decode("cursor") ?? cursor
        sprite = coder.decode("sprite") ?? sprite
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
        encoder.encode(cursor, key: "cursor")
        encoder.encode(sprite, key: "sprite")
    }

    func onSelected(selected: Bool) {
        cursor.selected = selected
    }

    override func populate() {
        self << sprite
    }

}
