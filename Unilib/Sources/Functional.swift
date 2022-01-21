//
//  Functional.swift
//  C3
//
//  Created by David James on 2021-12-07.
//  Copyright © 2021 David B James. All rights reserved.
//

import Foundation

/// Cache the result of a potentially expensive operation
/// by capturing the cache in the returned closure, storing
/// it somewhere, and then calling with the required input.
/// To store this, call it with the callback function signature
/// that performs the potentially expensive work (without
/// actually calling the callback), and then assign the resulting
/// closure to some location where it can be re-used by calling
/// the code with the same input type and getting back the same
/// output either as just-computed or already computed/cached.
///
/// The input type must be Hashable for the cache key.
/// See also `memoize()` that takes a custom cache key
/// if the input type cannot/should not be hashable.
///
///     // On the containing object:
///     let distanceCache = memoize(distance(rectangles:))
///     ...
///     // Somewhere that computes something:
///     distanceCache(.init(<input>))
public func memoize<I:Hashable,O>(_ closure:@escaping (I)->O) -> (_ input:I, _ debug:Bool)->O {
    var cache = [I:O]()
    return { input, debug in
        if let cached = cache[input] {
            if debug {
                ApiDebug()?.message("Memoized cache hit on \"\(input)\".", icon:"♻️").output()
            }
            return cached
        }
        let result = closure(input)
        cache[input] = result
        return result
    }
}

/// Cache the result of a potentially expensive operation
/// by capturing the cache in the returned closure, storing
/// it somewhere, and then calling with the required input.
/// To store this, call it with the callback function signature
/// that performs the potentially expensive work (without
/// actually calling the callback), and then assign the resulting
/// closure to some location where it can be re-used by calling
/// the code with the same input type and getting back the same
/// output either as just-computed or already computed/cached.
///
/// This method requires a custom Hashable cache key.
/// See also `memoize()` that does not require a custom cache
/// key if the input type is already Hashable.
///
///     // On the containing object:
///     let distanceCache = memoizeWithKey(CGPoint.self, distance(rectangles:))
///     ...
///     // Somewhere that computes something:
///     distanceCache(.init(<input>), key)
public func memoizeWithKey<I,O,Key:Hashable>(_:Key.Type, _ closure:@escaping (I)->O) -> (_ input:I, _ key:Key, _ debug:Bool)->O {
    var cache = [Key:O]()
    return { input, key, debug in
        if let cached = cache[key] {
            if debug {
                ApiDebug()?.message("Memoized cache hit on \"\(key)\".", icon:"♻️").output()
            }
            return cached
        }
        let result = closure(input)
        cache[key] = result
        return result
    }
}

// TODO document this when you've had a chance to try it.
public func memoizeRecursively<I:Hashable,O>(_ closure:@escaping ((I,Bool)->O,I)->O) -> (_ input:I, _ debug:Bool)->O {
    var cache = [I:O]()
    var memo:((I,Bool)->O)!
    memo = { input, debug in
        if let cached = cache[input] {
            if debug {
                ApiDebug()?.message("Memoized cache hit on \"\(input)\".", icon:"♻️").output()
            }
            return cached
        }
        let result = closure(memo, input)
        cache[input] = result
        return result
    }
    return memo
}
