//
//  MathOperators.swift
//  Unilib
//
//  Created by David James on 5/13/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation

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
