//
//  PropertyWrappers.swift
//  Unilib
//
//  Created by David James on 2019-10-01.
//  Copyright © 2019-2021 David B James. All rights reserved.
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

// MAINTENANCE: Sync the two blocks with and without SwiftUI

#if canImport(SwiftUI)
import SwiftUI

/// Property that cycles through integers
/// resetting to 0 when `max` is reached.
///
/// Alternatively, pass `min` to reset to
/// a number other than 0 and/or decrement
/// the number instead of incrementing.
/// You may also pass an initial starting
/// number from where to begin in the cycle.
///
///     @Cycled(min:1, max:5) var counter:Int = 2
///     ..
///     counter = 1 // increment
///     counter = -1 // decrement
@propertyWrapper
public struct Cycled : DynamicProperty {
    private let min:Int
    private let max:Int
    @State private var number:Int = 0
    public var wrappedValue:Int {
        get { return number }
        nonmutating set {
            guard newValue != 0 else { return }
            let newNumber = number + newValue
            if newValue < 0 { // decrementing
                if newNumber < min {
                    number = max
                } else {
                    number = newNumber
                }
            } else { // incrementing
                if newNumber > max {
                    number = min
                } else {
                    number = newNumber
                }
            }
        }
    }
    public var projectedValue:Binding<Int> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    public init(min:Int = 0, max:Int) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        self.min = min
        self.max = max
        self._number = State(wrappedValue:min)
    }
    public init(wrappedValue startingAt:Int, min:Int = 0, max:Int) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        self.min = min
        self.max = max
        self._number = State(wrappedValue:startingAt)
    }
    // Couldn't get this to work.. would just hit Int +=
    // Wanted syntax like: counter += 1
//    public static func +=(cycled:inout Self, value:Int) {
//        cycled.wrappedValue = value
//    }
}
#else
/// Property that cycles through integers
/// resetting to 0 when `max` is reached.
///
/// Alternatively, pass `min` to reset to
/// a number other than 0 and/or decrement
/// the number instead of incrementing.
/// You may also pass an initial starting
/// number from where to begin in the cycle.
///
///     @Cycled(min:1, max:5) var counter:Int = 2
///     ..
///     counter = 1 // increment
///     counter = -1 // decrement
@propertyWrapper
public struct Cycled {
    private let min:Int
    private let max:Int
    private var number:Int
    public var wrappedValue:Int {
        get { return number }
        nonmutating set {
            guard newValue != 0 else { return }
            let newNumber = number + newValue
            if newValue < 0 { // decrementing
                if newNumber < min {
                    number = max
                } else {
                    number = newNumber
                }
            } else { // incrementing
                if newNumber > max {
                    number = min
                } else {
                    number = newNumber
                }
            }
        }
    }
    public init(min:Int = 0, max:Int) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        self.min = min
        self.max = max
        self.number = min
    }
    public init(wrappedValue:Int, min:Int = 0, max:Int) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        self.min = min
        self.max = max
        self.number = wrappedValue
    }
}
#endif

/// Property that stores a closure, initially running
/// that closure and storing the return value as the
/// projected value of that type. This supports both
/// immediate use of the returned "projected" value
/// (e.g. "$foo") and the ability to rerun/refresh the
/// closure (e.g. "foo()"). The result of refreshing
/// may be used in a local variable (keeping the original
/// projected value intact) or assigned directly back to
/// the projected value, to update it (e.g. "$foo = foo()").
/// Alternatively, assign a new closure to this property
/// to update both the refreshable closure and projected value.
@propertyWrapper
public struct Refreshable<T> {
    public typealias Closure = ()->T
    private var closure:Closure
    public var projectedValue:T
    public var wrappedValue:Closure {
        get { return closure }
        set {
            closure = newValue
            projectedValue = self.closure()
        }
    }
    public init(wrappedValue closure:@escaping Closure) {
        self.closure = closure
        self.projectedValue = closure()
    }
}
