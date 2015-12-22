//
//  CFTimeIntervalExt.swift
//  FlatoutWar
//
//  Created by Colin Gray on 8/19/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

private let MaxTappedDuration = CFTimeInterval(0.375)

extension CFTimeInterval {
    var tappedDuration: Bool {
        return self < MaxTappedDuration
    }
}
