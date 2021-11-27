//
//  FloatingPoint.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017-2021 David B James. All rights reserved.
//

import Foundation
import CoreGraphics

public extension FloatingPoint {
    
    /// Take a floating point number and round it to the
    /// specified number of places, using "school-book rounding".
    func rounded(places:Int) -> Self {
        guard places > 0 else {
            return rounded()
        }
        let divisor = Self(Int(pow(10.0, Double(places))))
        return (self * divisor).rounded() / divisor
    }
    
    /// Take a floating point number and floor it (round down)
    /// to specified number of places.
    func floor(places:Int) -> Self {
        guard places > 0 else {
            return Foundation.floor(self)
        }
        let divisor = Self(Int(pow(10.0, Double(places))))
        return Foundation.floor(self * divisor) / divisor
    }
    
    /// Take a floating point number and ceiling it (round up)
    /// to specified number of places.
    func ceil(places:Int) -> Self {
        guard places > 0 else {
            return Foundation.ceil(self)
        }
        let divisor = Self(Int(pow(10.0, Double(places))))
        return Foundation.ceil(self * divisor) / divisor
    }
    
    // TEST the following API for viability.
    // It is intended to complement the Int.isMultiple() API
    // but for floating point numbers. There is some use
    // case already tested via "isRightAngleRadians" but
    // the whole "precision" aspect needs validation,
    // as that is what makes it useful.
    
    /// Is the current float a multiple of another float
    /// after rounding the current float up or down to a
    /// whole number using "school book rounding"?
    /// This is mainly useful in API that uses floats in place
    /// of integers where it is expected that the float will
    /// be a whole number in most cases.
    func isBasicallyMultiple(of multiple:Self) -> Bool {
        return isMultiple(of:multiple, withPrecision:0)
    }
    
    /// Is the current float a multiple of another float
    /// up to a certain precision (aka rounding "places").
    func isMultiple(of multiple:Self, withPrecision precision:Int) -> Bool {
        return self
            .rounded(places:precision)
            .truncatingRemainder(dividingBy:multiple) == 0
    }
    
    /// Is the current float an even number after rounding
    /// it up or down to a whole number.
    /// This is mainly useful in API that uses floats in place
    /// of integers where it is expected that the float will
    /// be a whole number in most cases.
    var isBasicallyEven:Bool {
        return rounded(places:0).truncatingRemainder(dividingBy:2) == 0
    }

    /// Is the current float precisely an even number.
    /// An even number is a whole number and a multiple of 2.
    var isPreciselyEven:Bool {
        return truncatingRemainder(dividingBy:2) == 0
    }
    
    /// Is the current float an odd number after rounding
    /// it up or down to a whole number.
    /// This is mainly useful in API that uses floats in place
    /// of integers where it is expected that the float will
    /// be a whole number in most cases.
    var isBasicallyOdd:Bool {
        return isOddWithPrecision(0)
    }
    
    /// Is the current float an odd number up to a certain
    /// precision (aka rounding "places").
    func isOddWithPrecision(_ precision:Int) -> Bool {
        return rounded(places:precision).truncatingRemainder(dividingBy:2) != 0
    }
}

public extension CGFloat {
    static let rightAngle:CGFloat = 1.570796327
    /// Is the float value equivalent to a right angle
    /// radian angle, which is equivalent to 0º, 90º,
    /// 180º or 270º.
    var isRightAngleRadians:Bool {
        // The following level of precision was chosen for practical
        // purposes related to how visible the difference actually
        // is when rotating objects by right angles.
        return isMultiple(of:1.57, withPrecision:2)
        // equivalent of:
        // return rounded(places:2).truncatingRemainder(dividingBy:1.57) == 0
    }
    /// Is the float value equivalent to a perpendicular
    /// radian angle, which is either 1.57 or -1.57 or,
    /// in degrees, 90º or 270º.
    var isPerpendicularRadians:Bool {
        return abs(rounded(places:2)) == 1.57
    }
    /// Reasonable value at which a scale transform is considered
    /// "non-visible". Having a non-zero value is important in
    /// case a scale transform is used in conjunction with animation.
    /// (i.e. animating an absolute "0.0" scale does not work)
    static let nonVisibleScale:CGFloat = 0.0001
}

public extension Int {
    var isEven:Bool {
        self % 2 == 0
    }
    var isOdd:Bool {
        self % 2 == 1
    }
}
