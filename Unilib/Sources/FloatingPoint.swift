//
//  FloatingPoint.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation
import CoreGraphics

public extension FloatingPoint {
    
    /// Take a floating point number and round it to the
    /// specified number of places.
    func rounded(places:Int) -> Self {
        let divisor = Self(Int(pow(10.0, Double(places))))
        return (self * divisor).rounded() / divisor
    }
    
    // BIGGER question with much of Unilib being public
    // is do we want users of ViewQuery (for pertinent example)
    // to have all of Unilib's interface showing up?
    // I think that would be detrimental to ViewQuery.
    // Solving many of these problems is not the purpose
    // of ViewQuery and users would need to import their
    // own dependencies if they want. Ultimately, Unilib
    // should be incorporated in ViewQuery, or at least
    // the parts that are being used.
    // Question however is this: If I use ViewQuery in a project
    // and I also want the functionality of Unilib it won't be available.
    // Will I need to maintain it in two separate places?
    
    // TODO: Replace this with Swift 5.0 isMultiple(of:)
    // and update isEven, isOdd to use them.
    
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

public extension CGFloat {
    static let rightAngle:CGFloat = 1.570796327
    var isRightAngleRadians:Bool {
        // The following level of precision was chosen for practical
        // purposes related to how visible the difference actually
        // is when rotating objects by right angles.
        return rounded(places:2).isMultipleOf(1.57)
    }
}

public extension Int {
    func isMultipleOf(_ multiple:Double) -> Bool {
        return Double(self).isMultipleOf(multiple)
    }
    
    var isEven:Bool {
        return Double(self).isEven
    }
    var isOdd:Bool {
        return Double(self).isOdd
    }
}
