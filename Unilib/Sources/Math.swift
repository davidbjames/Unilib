//
//  Math.swift
//  Unilib
//
//  Created by David James on 12/15/16.
//  Copyright © 2016-2020 David B James. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK:- Clamp

/// Clamp a float value to ensure it is between
/// a minimum and maximum bounds (inclusive).
public func clamp(_ value:CGFloat, min:CGFloat?, max:CGFloat?) -> CGFloat {
    switch (min, max) {
    case let (min?, max?) :
        return clampMin(clampMax(value, max:max), min:min)
    case (let min?, nil) :
        return clampMin(value, min:min)
    case (nil, let max?) :
        return clampMax(value, max:max)
    case (nil, nil) :
        return value
    }
}

/// Clamp a float value to ensure it is greater than
/// or equal to a minimum value.
public func clampMin(_ value:CGFloat, min:CGFloat) -> CGFloat {
    return value >= min ? value : min
}

/// Clamp a float value to ensure it is less than
/// or equal to a maximum value.
public func clampMax(_ value:CGFloat, max:CGFloat) -> CGFloat {
    return value <= max ? value : max
}

/// Clamp a float value to ensure it is within a range (inclusive).
public func clamp(_ value:CGFloat, to range:ClosedRange<CGFloat>) -> CGFloat {
    return clamp(value, min:range.lowerBound, max:range.upperBound)
}

/// Clamp a potentially inconsistent float value to a nearby multiple
/// rounding the multiple up or down per standard rounding.
public func clamp(_ input:CGFloat, toMultipleOf multiple:CGFloat) -> CGFloat {
    let fudged = input + (multiple / 2)
    let times = floor(fudged / multiple)
    return times * multiple
    
    // Tests:
    // Input:
    // [-132.5,  -90.0, -60.0, -0.0, 0.5, -0.6, 64.9,  65.0,  90.0, 129.2, 130.4, 130.6, 259.4, 262.7, 263.0]
    // .. with multiple of 130 ..
    // Output:
    // [-130.0, -130.0,   0.0,  0.0, 0.0,  0.0,  0.0, 130.0, 130.0, 130.0, 130.0, 130.0, 260.0, 260.0, 260.0]

}

public extension CGFloat {
    /// Clamp a float value to ensure it is between
    /// a minimum and maximum bounds (inclusive).
    func clamped(min:CGFloat, max:CGFloat) -> CGFloat {
        return clamp(self, min:min, max:max)
    }
    /// Clamp a float value to ensure it is within a range (inclusive).
    func clamped(to range:ClosedRange<CGFloat>) -> CGFloat {
        return clamp(self, to:range)
    }
    /// Clamp a potentially inconsistent float value to a nearby multiple
    /// rounding the multiple up or down per standard rounding.
    func clamped(toMultipleOf multiple:CGFloat) -> CGFloat {
        return clamp(self, toMultipleOf:multiple)
    }
}


/// Given a constant value that lies within an input range
/// produce a new value mapped to it's relative position
/// in an output range.
/// Optionally, invert the output mapping (i.e. so that
/// low input values map to high output values and vice versa).
public func map<F:BinaryFloatingPoint>(_ constant:F, from inputRange:ClosedRange<F>, to outputRange:ClosedRange<F>, inverted:Bool = false) -> F {
    // Linear transform (mapping):
    // MappedActual = (Actual-Min)/(Max-Min) * (MappedMax-MappedMin) + MappedMin
    // Example: compute offset based on device height
    // let offset = (height-minHeight)/(maxHeight-minHeight) * (maxOffset-minOffset) + minOffset.
    // or, map(1024, from:768...1024, to:30...50)
    // Given a larger device (1024 iPad 12.5):
    //      50   = (1024-768)/(1024-768) * (50-30) + 30
    // or medium size device (834 - iPad 10.5)
    //      35.2 = ( 834-768)/(1024-768) * (50-30) + 30
    // or smaller device (768 iPad 9.7):
    //      30   = ( 768-768)/(1024-768) * (50-30) + 30
    // inverted output range (iPad 12.5 to 9.7 respectively):
    //      30   = (1024-768)/(1024-768) * (30-50) + 50
    //      44.8 = ( 834-768)/(1024-768) * (30-50) + 50
    //      50   = ( 834-768)/(1024-768) * (30-50) + 50
    let inputMapping = (constant - inputRange.lowerBound) / (inputRange.upperBound - inputRange.lowerBound)
    if inverted {
        return inputMapping * (outputRange.lowerBound - outputRange.upperBound) + outputRange.upperBound
    } else {
        return inputMapping * (outputRange.upperBound - outputRange.lowerBound) + outputRange.lowerBound
    }
}


// MARK:- Angle

/// Simple struct representing an angle between 0º and 360º +/-
/// As this is ExpressibleByFloatLiteral, anywhere that takes
/// an Angle may also take a Double in it's place.
public/**/ struct Angle : ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    
    public/**/ typealias FloatLiteralType = Double
    public/**/ typealias IntegerLiteralType = Int

    public private(set) var degrees:Double

    /// Angle in radians
    /// Useful for core graphics/animations rotations
    public var radians:Double {
        return degrees * Double.pi / 180
    }
    
    /// Half the current rotation angle
    public var half:Angle {
        return self * 0.5
    }
    
    /// Double the current rotation angle
    public var double:Angle {
        return self * 2
    }
    
    /// Quadruple the current rotation angle
    public var quadruple:Angle {
        return self * 4
    }
    
    public/**/ init(floatLiteral value: Angle.FloatLiteralType) {
        self.degrees = value
    }

    public/**/ init(integerLiteral value: Int) {
        self.degrees = Double(value)
    }

    public/**/ init?(_ degrees:Double?) {
        guard let _degrees = degrees else { return nil }
        self.degrees = _degrees
    }
    
    public/**/ init?(_ degrees:CGFloat?) {
        self.init(degrees.flatMap { Double($0) })
    }
    
    // Creating new angles from simple arithmetic operators
    
    public static func + (lhs:Angle, rhs:Double) -> Angle {
        return Angle(floatLiteral:lhs.degrees + rhs)
    }
    
    public static func - (lhs:Angle, rhs:Double) -> Angle {
        return Angle(floatLiteral:lhs.degrees - rhs)
    }

    public static func / (lhs:Angle, rhs:Double) -> Angle {
        return Angle(floatLiteral:lhs.degrees / rhs)
    }

    public static func * (lhs:Angle, rhs:Double) -> Angle {
        return Angle(floatLiteral:lhs.degrees * rhs)
    }

}

// TODO: ✅ Genericize this, e.g. <T:BinaryFloatingPoint>

/// Container for functions that can be reused between
/// extensions of floating point types like Double or CGFloat.
/// Since iOS/Swift forces us to go back and forth between
/// Double and CGFloat, this prevents some code duplication,
/// though you still need to implement the method name
/// in each extension.
fileprivate struct FloatingPointHelper {
    
    /// Obtain a random positive/negative floating point number with an
    /// outer bound number (upper bound for positive numbers, negative bound
    /// for negative numbers). Negative numbers will return a random value
    /// between upper and 0, e.g. -10 returns a number between -10 and -0.
    static func randomDecimal(withBounds bounds:Double = 0.0) -> Double {
        
        //  Median      Deviation
        //   0.0 =    0.0  to  0.0 // no deviation (bounds 0.0)
        //   0.1 =    0.0  to  0.1 // small deviation
        //   0.5 =    0.0  to  0.5 // deviation up to 0.5 (half factor)
        //   1.0 =    0.0  to  1.0 // deviation up to 1 (1x factor)
        //   1.1 =    0.0  to  1.1 // etc
        //  10.0 =    0.0  to 10.0 //
        //  -0.1 =   -0.1  to -0.0 // negative deviation
        //  -0.5 =   -0.5  to -0.0 // small negative deviation
        //  -1.0 =   -1.0  to -0.0 // etc
        //  -1.1 =   -1.1  to -0.0 //
        // -10.0 =  -10.0  to -0.0 //
        
        var start:Double = 0.0
        var end:Double = 0.0
        
        if bounds != 0.0 {
            if bounds > 0.0 {
                end = abs(bounds)
            } else {
                start = bounds
            }
        }
        
        let range = Int(start * 100)...Int(end * 100)
        
        return Double(Int.random(in:range)) / 100
    }

    /// Obtain a random positive/negative factor number between a fraction and
    /// a whole number (e.g. 0.5 and 1.5) by providing a positive/negative
    /// "deviation" value. The deviation determines the range difference from 1.0
    /// so that a deviation of 0 equals a range of 1.0...1.0, which will only
    /// return 1.0. A deviation of 0.1 means a range of possible values in
    /// 0.9...1.1, etc. Deviations greater than 1.0 pin their bottom bound to
    /// 0.0, for example a deviation of 1.1 results in a random value in
    /// 0.0...2.1 (and not -0.1...2.1). Negative values act as expected and
    /// return random negative numbers, e.g. deviation of -2.0 returns a
    /// random value in -3.0...-0.0
    static func randomFactor(from deviation:Double = 0.0) -> Double {
        
        // Deviation outside of -1...+1 is pinned to 0 (start or end)
        
        // Deviation    Factors
        //   0.0 =    1.0  to  1.0 // factor of 1x only
        //   0.1 =    0.9  to  1.1 // near 1x factor +/-
        //   0.5 =    0.5  to  1.5 // half to 1.5 times
        //   1.0 =    0.0  to  2.0 // up to 2x
        //   1.1 =    0.0  to  2.1 // etc (from 0 to n+1x)
        //  10.0 =    0.0  to 11.0 // etc
        //  -0.1 =   -1.1  to -0.9 // near 1x negative factor
        //  -0.5 =   -1.5  to -0.5 // half to 1.5x negative factor
        //  -1.0 =   -2.0  to  0.0 // up to 2x negative factor
        //  -1.1 =   -2.1  to  0.0 // etc
        // -10.0 =  -11.0  to  0.0 // etc
        
        var start:Double = 1.0
        var end:Double = 1.0
        
        if deviation != 0.0 {
            if deviation > 0.0 {
                start = max(1.0 - deviation, 0.0)
                end = 1.0 + deviation
            } else {
                start = -(1.0 + abs(deviation))
                end = min(-(1.0 - abs(deviation)), -0.0)
            }
        }
        let range = Int(start * 100)...Int(end * 100)
        return Double(Int.random(in:range)) / 100
    }
    
    /// Obtain a random positive factor number between a fraction
    /// a whole number (e.g. 0.5 and 1.5) by providing a positive
    /// initial factor value (e.g. 1.5). The initial value provided
    /// is the "target" factor which is above or below 1.0. The
    /// return value will be within the range between that target
    /// value and it's "mirror value on the opposite side of 1.0".
    /// E.g. providing 1.5 will return a random value between 0.5 and 1.5.
    static func randomOneFactor(from value:Double = 0.0) -> Double {
        let deviation = abs(1 - value)
        return randomFactor(from:deviation)
    }
    
    /// Obtain a random positive/negative deviation number from a median
    /// number with the range being 0.0...(median*2).
    static func randomMedianDeviation(from median:Double = 0.0) -> Double {
        
        //  Median      Deviation
        //   0.0 =    0.0  to  0.0 // no deviation
        //   0.1 =    0.0  to  0.2 // small deviation
        //   0.5 =    0.0  to  1.0 // deviation up to 1 (factor of 1?)
        //   1.0 =    0.0  to  2.0 // deviation up to 2 (2x factor?)
        //   1.1 =    0.0  to  2.2 // etc
        //  10.0 =    0.0  to 20.0 //
        //  -0.1 =   -0.2  to -0.0 // negative deviation
        //  -0.5 =   -1.0  to -0.0 // small negative deviation
        //  -1.0 =   -2.0  to -0.0 // etc
        //  -1.1 =   -2.2  to -0.0 //
        // -10.0 =  -20.0  to -0.0 //
        
        var start:Double = 0.0
        var end:Double = 0.0
        
        if median != 0.0 {
            if median > 0.0 {
                end = median * 2
            } else {
                start = -(abs(median) * 2)
                end = -0.0
            }
        }
        
        let range = Int(start * 100)...Int(end * 100)
        return Double(Int.random(in:range)) / 100
    }
    
    /// Obtain a random positive/negative deviation number from an upper
    /// bound number using 0 as the median. e.g. 0.1 would return a random
    /// number between -0.1 and 0.1, 10 would return between -10 and 10.
    static func randomZeroDeviation(from upper:Double = 0.0) -> Double {
        
        let unsigned = abs(upper)
        //  Median      Deviation
        //   0.0 =    0.0  to  0.0 // no deviation
        //   0.1 =   -0.1  to  0.1 // small deviation
        //   0.5 =   -0.5  to  0.5 // deviation up to 0.5 (half factor)
        //   1.0 =   -1.0  to  1.0 // deviation up to 1 (1x factor)
        //   1.1 =   -1.1  to  1.1 // etc
        
        let start:Double = -(unsigned)
        let end:Double = unsigned
        
        let range = Int(start * 100)...Int(end * 100)
        return Double(Int.random(in:range)) / 100

//        print("---------------------------")
//        print("upper    :", upper)
//        print("start    :", start)
//        print("end      :", end)
//        print("range    :", range)
//        print("deviation:", deviation)
    }

}

public extension Double {
    
    /// Equivalent in radians
    var radians:Double {
        return Angle(floatLiteral:self).radians
    }
    
    /// Based on a floating point number, get a random value up
    /// to that number. The number provided represents the outer
    /// bounds, positive or negative.
    /// Example:
    /// -1.0.randomDecimal provides a random number betwen -1.0 and 0.0
    /// See private static method for more info.
    var randomDecimal:Double {
        return FloatingPointHelper.randomDecimal(withBounds: self)
    }
    
    /// Based on a floating point number, get a random factor between 
    /// (1 - number) and (1 + number), with the resulting value being useful
    /// to decrease/increase some other value "by a factor of".
    /// Supports negative numbers.
    /// Example:
    /// 0.1.randomFactor provides a random number between 0.9 and 1.1
    ///   let size = 100.0
    ///   let scaled = size * 0.1.randomFactor
    ///   scaled // between 90 and 110
    /// See private static method for more info.
    var randomFactor:Double {
        return FloatingPointHelper.randomFactor(from:self)
    }
    
    /// Based on a floating point number, get a random factor between
    /// that number and it's converse on the opposite side of 1.0
    /// with the resulting value being useful to decrease/increase
    /// some other value "by a factor of".
    /// Example:
    /// 1.5.randomOneFactor provides a random number between 0.5 and 1.5
    var randomOneFactor:Double {
        return FloatingPointHelper.randomOneFactor(from:self)
    }
    
    /// Based on a floating point number, get a random value between
    /// 0.0 and (number x 2). The number provided represents the
    /// "median deviation", with the lower bounds being 0.0 and
    /// the upper bounds being the number doubled (thus making the
    /// number the middle value). e.g. for 1: 0 lower -- 1 median -- 2 upper. 
    /// Supports negative numbers.
    /// Example:
    /// 1.0.randomMedianDeviation provides a random number between 0.0 and 2.0
    ///   let increment = 2.0
    ///   let randomIncrement = increment + 1.0.randomMedianDeviation
    ///   randomIncrement // between 2.0 and 4.0
    /// See private static method for more info.
    var randomMedianDeviation:Double {
        return FloatingPointHelper.randomMedianDeviation(from: self)
    }
    
    /// Based on a floating point number, get a random value between
    /// -number and +number. The number provided represents the
    /// lower (negative) and upper (positive) bounds of the range.
    /// Example:
    /// 0.1.randomZeroDeviation provides a random number between -0.1 and 0.1
    ///   let position = 150.0
    ///   let randomPosition = position + 10.randomZeroDeviation
    ///   randomPosition // between 140 and 160
    /// See private static method for more info.
    var randomZeroDeviation:Double {
        return FloatingPointHelper.randomZeroDeviation(from: self)
    }
    
}

public extension CGFloat {

    var radians:CGFloat {
        return CGFloat(Angle(floatLiteral:Double(self)).radians)
    }
    
    var randomDecimal:CGFloat {
        return CGFloat(FloatingPointHelper.randomDecimal(withBounds: Double(self)))
    }

    var randomFactor:CGFloat {
        return CGFloat(FloatingPointHelper.randomFactor(from:Double(self)))
    }
    
    var randomOneFactor:CGFloat {
        return CGFloat(FloatingPointHelper.randomOneFactor(from:Double(self)))
    }

    var randomMedianDeviation:CGFloat {
        return CGFloat(FloatingPointHelper.randomMedianDeviation(from: Double(self)))
    }
    
    var randomZeroDeviation:CGFloat {
        return CGFloat(FloatingPointHelper.randomZeroDeviation(from: Double(self)))
    }
    
}

