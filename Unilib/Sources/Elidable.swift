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
/// Currently available on arrays, Query, Mutator, AutoLayout,
/// all animators, and gesture and list publishers.
public/**/ protocol Elidable {
    func `if`(_ condition:Bool, then closure:(Self)->Self, `else`:((Self)->Self)?) -> Self
    func `switch`<T>(_ input:T?, _ cases:[T:(Self)->Self], `default`:((Self)->Self)?, finally:((Self)->Self)?) -> Self
    func ifLet<Thing>(_ thing:Thing?, then closure:(Self,Thing)->Self, `else`:((Self)->Self)?) -> Self
    func `guard`(_ condition:Bool, `else`:((Self)->Void)?) -> Self?
    func guardLet<Thing>(_ thing:Thing?, finally closure:(Self,Thing)->Self, `else`:((Self)->Void)?) -> Self?
}

public/**/ extension Elidable {
    /// Chainable if/else operator using an external condition.
    ///
    /// If the condition evaluates to true then execute
    /// `then` closure returning new self, otherwise return self as-is.
    /// Optionally, provide trailing `else` block and return new self.
    ///
    ///     .if(condition) { wrapper in
    ///         wrapper.doFoo() // returns to outer chain
    ///     } else: { wrapper in
    ///         wrapper.doBar() // returns to outer chain
    ///     }
    ///     ..
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
    ///
    ///     .ifLet(thing) { wrapper, thing in
    ///         wrapper.doFoo(with:thing) // returns to outer chain
    ///     } else: { wrapper in
    ///         wrapper.doBar() // returns to outer chain
    ///     }
    ///     ..
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
    /// Optionally, provide a `default` closure if no match.
    /// Optionally, provide a `finally` closure that is fired
    /// regardless of a match. It can apply to the match closure,
    /// default closure or self, potentially modifying the chain.
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
    ///     ], default: {
    ///         $0.baz()
    ///     }, finally: {
    ///         $0.bop()
    ///     })
    ///     
    /// Alternatively, if you need a true Swift `switch` statement,
    /// wrap the `switch` in `aside` (if you don't need the return type)
    /// or `elide` (if you need the return type). (`aside` and `elide`
    /// operators available on conforming types.)
    @discardableResult
    func `switch`<T>(_ input:T?, _ cases:[T:(Self)->Self], default defaultClosure:((Self)->Self)? = nil, finally:((Self)->Self)? = nil) -> Self {
        for (value, predicate) in cases {
            if value == input {
                if let finally = finally {
                    return finally(predicate(self))
                }
                return predicate(self)
            }
        }
        if let finally = finally {
            if let defaultClosure = defaultClosure {
                return finally(defaultClosure(self))
            } else {
                return finally(self)
            }
        } else {
            if let defaultClosure = defaultClosure {
                return defaultClosure(self)
            } else {
                return self
            }
        }
    }
    /// Chainable guard/else operator using external condition.
    ///
    /// In order to proceed with self chain the condition must
    /// evaluate to true, otherwise self chain is broken (nil return).
    /// Optionally, provide trailing `else` block to perform side effects.
    ///
    ///     .guard(condition) { wrapper in
    ///         wrapper.doFoo() // returns to outer chain
    ///     } else: { wrapper in
    ///         wrapper.doSideEffect() // does not return, chain is broken
    ///     }?
    ///     ..
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
    /// block to act on and return a new self (or self as-is).
    /// Optionally, provide trailing `else` block to perform side effects.
    ///
    ///     .guardLet(thing) { wrapper, thing in
    ///         wrapper.doFoo(with:thing) // returns to outer chain
    ///     } else: { wrapper
    ///         wrapper.doSideEffect() // does not return, chain is broken
    ///     }?
    ///     ..
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

