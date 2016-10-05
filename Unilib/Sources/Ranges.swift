//
//  Ranges.swift
//  Unilib
//
//  Copyright © 2016 David James. All rights reserved.
//

import Foundation

public extension CountableClosedRange {
    
    /// Grab a random number from a range of numbers
    var random: Int {
        get {
            var offset = 0
            let start = lowerBound as! Int
            let end = upperBound as! Int
            if start < 0 {  // allow negative ranges
                offset = abs(start)
            }
            let min = UInt32(start + offset)
            let max = UInt32(end + offset)
            return Int(min + arc4random_uniform(max - min)) - offset
        }
    }
}
