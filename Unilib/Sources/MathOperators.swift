//
//  MathOperators.swift
//  Unilib
//
//  Created by David James on 5/13/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation
import CoreGraphics

// Float / Int basic math interactivity.
// Prevents compiler errors when performing binary operations on them.

func * (lhs:Int, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

func * (lhs:Int, rhs:Double) -> Double {
    return Double(lhs) * rhs
}

func * (lhs:CGFloat, rhs:Int) -> CGFloat {
    return lhs * CGFloat(rhs)
}

func * (lhs:Double, rhs:Int) -> Double {
    return lhs * Double(rhs)
}



func / (lhs:Int, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}

func / (lhs:Int, rhs:Double) -> Double {
    return Double(lhs) / rhs
}

func / (lhs:CGFloat, rhs:Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}

func / (lhs:Double, rhs:Int) -> Double {
    return lhs / Double(rhs)
}



func + (lhs:Int, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}

func + (lhs:Int, rhs:Double) -> Double {
    return Double(lhs) + rhs
}

func + (lhs:CGFloat, rhs:Int) -> CGFloat {
    return lhs + CGFloat(rhs)
}

func + (lhs:Double, rhs:Int) -> Double {
    return lhs + Double(rhs)
}



func - (lhs:Int, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}

func - (lhs:Int, rhs:Double) -> Double {
    return Double(lhs) - rhs
}

func - (lhs:CGFloat, rhs:Int) -> CGFloat {
    return lhs - CGFloat(rhs)
}

func - (lhs:Double, rhs:Int) -> Double {
    return lhs - Double(rhs)
}


// Maybe move this to OtherOperators file

infix operator ^^

/// The missing XOR operator.
/// True if one is true but NOT the other.
public func ^^(lhs:Bool, rhs:Bool) -> Bool {
    return lhs != rhs
}
/*
false ^^ false // false
true  ^^ true  // false
false ^^ true  // true
true  ^^ false // true
*/
