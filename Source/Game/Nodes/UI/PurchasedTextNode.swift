//
//  PurchasedTextNode.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/23/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PurchasedTextNode: TextNode {
    var purchased: Int = 0 { didSet { updateText() } }
    var max: Int = 0 { didSet { updateText() } }

    private func updateText() {
        var text = ""
        for i in 0..<max {
            if purchased > i {
                text += "•"
            }
            else {
                text += "◦"
            }
        }
        self.text = text
    }
}
