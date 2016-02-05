//
//  PauseButton.swift
//  FlatoutWar
//
//  Created by Colin Gray on 1/3/2016.
//  Copyright (c) 2016 FlatoutWar. All rights reserved.
//

class PauseButton: Button {

    required init() {
        super.init()

        touchableComponent?.off(.UpInside)
        touchableComponent?.on(.Down) { _ in
            for handler in self._onTapped {
                handler()
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
