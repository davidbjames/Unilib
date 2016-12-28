//
//  Math.swift
//  Unilib
//
//  Created by David James on 12/15/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

public struct Angle {
    
    private var degrees:Double

    public var radians:Double {
        return degrees * Double.pi / 180
    }
    
    public var half:Angle {
        return self.by(factor: 0.5)
    }
    
    public var double:Angle {
        return self.by(factor: 2)
    }
    
    public var quadruple:Angle {
        return self.by(factor: 4)
    }

    public init(_ degrees:Double) {
        if degrees >= -360 && degrees <= 360 {
            self.degrees = degrees
        } else {
            self.degrees = 0
            print("🔥 WARNING: Angle initialized with degree outside of 0-360º(+/-). Defaulting to 0º. Use factoring methods/getters to increase degrees.")
        }
    }
    
    public func by(factor:Double) -> Angle {
        var newAngle = self
        newAngle.degrees = self.degrees * factor
        return newAngle
    }
}
