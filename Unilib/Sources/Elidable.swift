//
//  Elidable.swift
//  Unilib
//
//  Created by David James on 2022-01-10.
//  Copyright © 2022 David B James. All rights reserved.
//

import Foundation

/// Support conditional inline logic in chainable interfaces.
///
/// Currently used with QueryInterface (Query/Mutator/AutoLayout),
/// Animator (all types) and Gesture interface.
public protocol Elidable {
    func `if`(_ condition:Bool, then closure:(Self)->Self, `else`:((Self)->Self)?) -> Self
    func `switch`<T>(_ input:T, _ cases:[T:(Self)->Self]) -> Self
    func ifLet<Thing>(_ thing:Thing?, then closure:(Self,Thing)->Self, `else`:((Self)->Self)?) -> Self
    func `guard`(_ condition:Bool, `else`:((Self)->Void)?) -> Self?
    func guardLet<Thing>(_ thing:Thing?, finally closure:(Self,Thing)->Self, `else`:((Self)->Void)?) -> Self?
}

public extension Elidable {
    /// Chainable if/else operator using an external condition.
    ///
    /// If the condition evaluates to true then execute
    /// `then` closure returning new self, otherwise return self as-is.
    /// Optionally, provide trailing `else` block and return new self.
    @discardableResult
    func `if`(_ condition:Bool, then closure:(Self)->Self, `else`:((Self)->Self)? = nil) -> Self {
        if condition  {
            return closure(self)
        } else if let other = `else` {
            return other(self)
        } else {
            return self
        }
    }
    /// Chainable if-let/else operator using external optional.
    ///
    /// If the binding/unwrapping succeeds, this executes the
    /// `then` closure passing the self and the unwrapped thing,
    /// otherwise returns self as-is.
    /// Optionally, provide trailing `else` block and return new self.
    @discardableResult
    func ifLet<Thing>(_ thing:Thing?, then closure:(Self,Thing)->Self, `else`:((Self)->Self)? = nil) -> Self {
        if let thing = thing {
            return closure(self, thing)
        } else if let other = `else` {
            return other(self)
        } else {
            return self
        }
    }
    /// Chainable "switch" operator with input value and series
    /// of value/closure tuples with the first input-value match
    /// causing the closure to be run and resulting self returned.
    ///
    /// This isn't really a switch operator (no pattern matching,
    /// only equality (same type)) but is useful when there are
    /// multiple possible branches, without breaking the chain.
    /// Example:
    ///
    ///     .switch(number, [
    ///         1 : {
    ///             $0.foo()
    ///         },
    ///         2 : {
    ///             $0.bar()
    ///         }
    ///     ])
    @discardableResult
    func `switch`<T>(_ input:T, _ cases:[T:(Self)->Self]) -> Self {
        for (value, predicate) in cases {
            if value == input {
                return predicate(self)
            }
        }
        return self
    }
    /// Chainable guard/else operator using external condition.
    ///
    /// In order to proceed with self chain the condition must
    /// evaluate to true, otherwise self chain is broken (nil return).
    /// Optionally, provide trailing `else` block to perform side effects.
    @discardableResult
    func `guard`(_ condition:Bool, `else`:((Self)->Void)? = nil) -> Self? {
        if condition {
            return self
        } else if let other = `else` {
            other(self)
            return nil
        } else {
            return nil
        }
    }
    /// Chainable guard-let/else operator using external optional.
    ///
    /// In order to proceed with self chain the optional thing
    /// must exist, else the self chain is broken (nil return).
    /// If the optional does exist it will be passed to a `finally`
    /// block to act on and return a new animator (or self as-is).
    /// Optionally, provide trailing `else` block to perform side effects.
    @discardableResult
    func guardLet<Thing>(_ thing:Thing?, finally closure:(Self,Thing)->Self, `else`:((Self)->Void)? = nil) -> Self? {
        if let thing = thing {
            return closure(self, thing)
        } else if let other = `else` {
            other(self)
            return nil
        } else {
            return nil
        }
    }
}

