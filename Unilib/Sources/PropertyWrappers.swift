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

// DEV NOTE: @Cycled may only be used in a SwiftUI context
// because SwiftUI manages its state (with updates) within a View.
// To get the same functionality (but without updates) use @CycledRaw.
// This has been tested on a UIViewController.
// @Cycled does not work there, @CycledRaw does (but without updates).

// MAINTENANCE: Sync the two blocks with and without SwiftUI

#if canImport(SwiftUI)
import SwiftUI

/// Property that cycles through numbers
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
/// Optionally, make the cycling `reversible`
/// in either direction, so instead of starting
/// again, it reverses when it reaches min/max.
/// Alternatively, make this `finite` so that
/// it stops when its bound is reached.
@propertyWrapper
public struct Cycled<T:SignedNumeric & Comparable> : DynamicProperty {
    /// Type of cycling behavior
    public enum Mode {
        /// Cycle numbers from beginning and when
        /// reaching the end, start at the beginning.
        /// Default cycling behavior.
        case repeatable
        /// Cycle numbers from beginning and when
        /// reaching the end, go back to the beginning
        /// and vice versa.
        case reversible
        /// Cycle numbers from beginning and when
        /// reaching the end, stop.
        case finite
    }
    private let min:T
    private let max:T
    private let mode:Mode
    private var reversible:Bool {
        mode == .reversible
    }
    private var finite:Bool {
        mode == .finite
    }
    @State private var number:T = 0
    @State private var shouldReverse:Bool = false
    public var wrappedValue:T {
        get { return number }
        nonmutating set {
            guard newValue != T.zero else { return }
            let value = shouldReverse ? -newValue : newValue
            let newNumber = number + value
            if value < T.zero { // decrementing
                if newNumber < min {
                    if reversible || finite {
                        // Past min value, clamp to min.
                        // It will either start going back the opposite way
                        // for "reversible" or just stay there for "finite".
                        number = min
                    } else {
                        // Past min, start again at max. "repeatable"
                        number = max
                    }
                } else {
                    number = newNumber
                }
            } else { // incrementing
                if newNumber > max {
                    if reversible || finite {
                        number = max
                    } else {
                        number = min
                    }
                } else {
                    number = newNumber
                }
            }
            if reversible && (number == min || number == max) {
                shouldReverse.toggle()
            }
        }
    }
    public var projectedValue:Binding<T> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    public init(min:T = T.zero, max:T, mode:Mode? = nil) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        self.min = min
        self.max = max
        self.mode = mode ?? .repeatable
        self._number = State(wrappedValue:min)
    }
    public init(wrappedValue startingAt:T, min:T = T.zero, max:T, mode:Mode? = nil) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        guard startingAt >= min && startingAt <= max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with initial start value (\(startingAt)) that is not within min (\(min)) and max (\(max)) values inclusive.")
        }
        self.min = min
        self.max = max
        self.mode = mode ?? .repeatable
        self._number = State(wrappedValue:startingAt)
    }
    public var atMin:Bool {
        wrappedValue <= min
    }
    public var atMax:Bool {
        wrappedValue >= max
    }
    // Couldn't get this to work.. would just hit Int +=
    // Wanted syntax like: counter += 1
//    public static func +=(cycled:inout Self, value:Int) {
//        cycled.wrappedValue = value
//    }
}
#endif

/// Property that cycles through numbers
/// resetting to 0 when `max` is reached.
///
/// Alternatively, pass `min` to reset to
/// a number other than 0 and/or decrement
/// the number instead of incrementing.
/// You may also pass an initial starting
/// number from where to begin in the cycle.
///
///     @CycledRaw(min:1, max:5) var counter:Int = 2
///     ..
///     counter = 1 // increment
///     counter = -1 // decrement
/// Optionally, make the cycling `reversible`
/// in either direction, so instead of starting
/// again, it reverses when it reaches min/max.
/// Alternatively, make this `finite` so that
/// it stops when its bound is reached.
/// See also @Cycled if this is used in SwiftUI.
@propertyWrapper
public struct CycledRaw<T:SignedNumeric & Comparable> {
    public enum Mode {
        case repeatable, reversible, finite
    }
    private let min:T
    private let max:T
    private let mode:Mode
    private var reversible:Bool {
        mode == .reversible
    }
    private var finite:Bool {
        mode == .finite
    }
    private var shouldReverse:Bool = false
    private var number:T
    public var wrappedValue:T {
        get { return number }
        set {
            guard newValue != T.zero else { return }
            let value = shouldReverse ? -newValue : newValue
            let newNumber = number + value
            if newValue < T.zero { // decrementing
                if newNumber < min {
                    if reversible || finite {
                        number = min
                    } else {
                        number = max
                    }
                } else {
                    number = newNumber
                }
            } else { // incrementing
                if newNumber > max {
                    if reversible || finite {
                        number = max
                    } else {
                        number = min
                    }
                } else {
                    number = newNumber
                }
            }
            if reversible && (number == min || number == max) {
                shouldReverse.toggle()
            }
        }
    }
    public init(min:T = T.zero, max:T, mode:Mode? = nil) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        self.min = min
        self.max = max
        self.mode = mode ?? .repeatable
        self.number = min
    }
    public init(wrappedValue startingAt:T, min:T = T.zero, max:T, mode:Mode? = nil) {
        guard min < max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with min value that is greater than or equal to max value.")
        }
        guard startingAt >= min && startingAt <= max else {
            preconditionFailure("Attempt to initialize @Cycled property wrapper with initial start value (\(startingAt)) that is not within min (\(min)) and max (\(max)) values inclusive.")
        }
        self.min = min
        self.max = max
        self.mode = mode ?? .repeatable
        self.number = startingAt
    }
    public var atMin:Bool {
        wrappedValue <= min
    }
    public var atMax:Bool {
        wrappedValue >= max
    }
}

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
