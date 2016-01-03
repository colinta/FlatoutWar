//
//  PauseButton.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PauseButton: ButtonNode {

    required init() {
        super.init()

        touchableComponent?.off(.Pressed)
        touchableComponent?.on(.Down) { _ in
            self._onTapped?()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
