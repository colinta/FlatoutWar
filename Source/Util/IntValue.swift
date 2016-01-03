//
//  IntValue.swift
//  FlatoutWar
//
//  Created by Colin Gray on 12/29/2015.
//  Copyright (c) 2015 FlatoutWar. All rights reserved.
//

protocol IntValue {
    var int: Int { get }
}

// MARK: IntValue <=> Int

func <(intValue: IntValue, int: Int) -> Bool {
    return intValue.int < int
}

func <=(intValue: IntValue, int: Int) -> Bool {
    return intValue.int <= int
}

func >(intValue: IntValue, int: Int) -> Bool {
    return intValue.int > int
}

func >=(intValue: IntValue, int: Int) -> Bool {
    return intValue.int >= int
}

// MARK: Int <=> IntValue

func <(int: Int, intValue: IntValue) -> Bool {
    return int < intValue.int
}

func <=(int: Int, intValue: IntValue) -> Bool {
    return int <= intValue.int
}

func >(int: Int, intValue: IntValue) -> Bool {
    return int > intValue.int
}

func >=(int: Int, intValue: IntValue) -> Bool {
    return int >= intValue.int
}

// MARK: IntValue <=> IntValue

func <(lhs: IntValue, rhs: IntValue) -> Bool {
    return lhs.int < rhs.int
}

func <=(lhs: IntValue, rhs: IntValue) -> Bool {
    return lhs.int <= rhs.int
}

func ==(lhs: IntValue, rhs: IntValue) -> Bool {
    return lhs.int == rhs.int
}

func >(lhs: IntValue, rhs: IntValue) -> Bool {
    return lhs.int > rhs.int
}

func >=(lhs: IntValue, rhs: IntValue) -> Bool {
    return lhs.int >= rhs.int
}
