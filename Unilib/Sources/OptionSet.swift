//
//  OptionSet.swift
//  Unilib
//
//  Created by David James on 5/23/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation


public extension OptionSet where RawValue : Integer {
    
    // Care of Martin R on Stack Overflow
    // https://stackoverflow.com/questions/32102936/how-do-you-enumerate-optionsettype-in-swift#32103136

    /// Get the individual elements of an OptionSet
    func elements() -> AnySequence<Self> {
        var remainingBits = rawValue
        var bitMask: RawValue = 1
        return AnySequence {
            return AnyIterator {
                while remainingBits != 0 {
                    defer { bitMask = bitMask &* 2 }
                    if remainingBits & bitMask != 0 {
                        remainingBits = remainingBits & ~bitMask
                        return Self(rawValue: bitMask)
                    }
                }
                return nil
            }
        }
    }
}
