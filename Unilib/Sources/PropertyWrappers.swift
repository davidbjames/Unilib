//
//  PropertyWrappers.swift
//  Unilib
//
//  Created by David James on 2019-10-01.
//  Copyright © 2019 David B James. All rights reserved.
//

import Foundation

/// Property that is guaranteed to never be less than 0
/// with a projected boolean value to indicate when
/// the value is greater than 0.
@propertyWrapper
public struct MinZero {
    private var number = 0
    public var projectedValue = false
    public var wrappedValue:Int {
        get { return number }
        set {
            if newValue < 0 {
                number = 0
            } else {
                number = newValue
            }
            projectedValue = number > 0
        }
    }
    public init(wrappedValue:Int) {
        // NOTE: This specific initializer is necessary in case
        // you must create this property with an initial value.
        // Example: @MinZero var test = 3
        // On the other hand, to create this property with any
        // other value you must create another initializer for
        // that value. Example: @Min(min:2) var test.
        // To combine both a custom initial value and the initial
        // value of the wrapped value, you must create yet another
        // initializer that does both, with wrappedValue first:
        // init(wrappedValue:Int, min:Int) and call it like
        // @Min(min:2) var test = 5
        // which synthesizes to: Min(wrappedValue:5, min:2).
        number = wrappedValue
    }
}

/// Property that cycles through integers
/// resetting to 0 when max is reached.
/// Example: @Cycled(max:2) var counter:Int
@propertyWrapper
public struct Cycled {
    private let max:Int
    private var number = 0
    public var wrappedValue:Int {
        get { return number }
        set {
            let newNumber = number + newValue
            if newNumber > max {
                number = 0
            } else {
                number = newNumber
            }
        }
    }
    public init(max:Int) {
        self.max = max
        self.number = 0
    }
}

/// Property that stores a closure, initially running
/// that closure and storing the return value as
/// the projected value of that type. This supports
/// both immediate use of the returned "projected" value
/// (via "$foo" syntax) and the ability to rerun the closure
/// (via "foo()") and use that value, while retaining
/// the original value intact (i.e. the $projected value).
@propertyWrapper
public struct Refreshable<T> {
    private var closure:()->T
    public var projectedValue:T
    public var wrappedValue:()->T {
        get { return closure }
        set {
            self.closure = newValue
            projectedValue = self.closure()
        }
    }
    public init(wrappedValue closure:@escaping ()->T) {
        self.closure = closure
        self.projectedValue = closure()
    }
}
