//
//  FloatingPoint.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation

public extension FloatingPoint {
    
    /// Take a floating point number and round it to the
    /// specified number of places.
    func rounded(places:Int) -> Self {
        let divisor = Self(Int(pow(10.0, Double(places))))
        return (self * divisor).rounded() / divisor
    }
    
    /// Is the current number a multiple of another.
    func isMultipleOf(_ multiple:Self) -> Bool {
        return self.truncatingRemainder(dividingBy: multiple) == 0
    }
    
    var isEven:Bool {
        return self.truncatingRemainder(dividingBy:2) == 0
    }
    var isOdd:Bool {
        return self.truncatingRemainder(dividingBy:2) != 0
    }
}
