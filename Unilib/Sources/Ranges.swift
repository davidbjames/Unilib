//
//  Ranges.swift
//  Unilib
//
//  Copyright © 2016-2020 David James. All rights reserved.
//

import Foundation

// MAINTENANCE:
// For Theme operators that take ranges of Ordinals
// the following API must remain "public". This is
// an exception to most Unilib API which is normally
// "internal". See Unilib README for more information.
// The "/**/" notation is used to protect this API
// from being flipped back to internal.

/// Type erasure wrapper for RangeExpression in case it's not
/// practical for your API to provide the genericity necessary
/// to support RangeExpression (which has an associated type).
/// Primarily provides the ability to check if a range contains an item.
public/**/ struct AnyRangeExpression<B, C:Collection> : RangeExpression where B == C.Index {
    
    private let _contains:(B)->Bool
    private let _relativeTo:(C)->Range<B>
    
    init<R:RangeExpression>(range:R) where R.Bound == B {
        self._contains = { bound in
            range.contains(bound)
        }
        self._relativeTo = { collection in
            range.relative(to:collection)
        }
    }
    public/**/ func contains(_ element: B) -> Bool {
        _contains(element)
    }
    public/**/ func relative<_C:Collection>(to collection: _C) -> Range<B> where B == _C.Index {
        guard _C.self == C.self else {
            preconditionFailure("Attempt to use relative(to:) on type erased AnyRangeExpression fails because the collection element type provided is not the same as the element type on the type erased wrapper.")
        }
        return _relativeTo(collection as! C)
    }
}
extension AnyRangeExpression : CustomStringConvertible where B == Int {
    public/**/ var description: String {
        // Since the type erasure is closing over (hiding) the concrete range,
        // for integer type ranges, we need to use relative(to:) to map indices
        // from 0 to the actual range with the return value representing the
        // values of the actual range, e.g. 2...
        // (The following Array created from any other range (e.g. 100...200)
        // would have the same results because it's just used to for it's indices.)
        // (see also relative(to:) documentation)
        "\(relative(to:Array(0...100)))"
    }
}

/// An array of RangeExpressions that itself can be
/// treated as a RangeExpression.
extension Array : RangeExpression where Element:RangeExpression {
    public/**/ func contains(_ element: Element.Bound) -> Bool {
        contains(where:{ $0.contains(element) })
    }
    public/**/ func relative<C>(to collection: C) -> Range<Element.Bound> where C : Collection, Self.Element.Bound == C.Index {
        preconditionFailure("Not implemented.")
    }
}

/// A type erased range expression that can be used in
/// places that must support heterogenous range types.
/// Example:
///
///     [+(0...5), +8, +(10...)]
public/**/ prefix func +<R:RangeExpression>(_ range:R) -> AnyRangeExpression<R.Bound, [R.Bound]> {
    AnyRangeExpression(range:range)
}

/*
func test() {
    // Example with the same range expression types.
    _ = [0...3, 6...9].relative(to:["something"])
    // Example with diverse range expression types
    // by using AnyRangeExpression.
    _ = [AnyRangeExpression<Int, [Int]>(range: 0...5), AnyRangeExpression<Int, [Int]>(range:8), AnyRangeExpression<Int, [Int]>(range:8...)].relative(to:[3])
    // Example with diverse range expression types
    // using prefix shorthand for AnyRangeExpression.
    _ = [+(0...5), +10..., +(...8), +(..<8), +2].relative(to:[3])
    // (closed range, partial from, partial through, partial up to, single int)
    
    // Same examples passed to Theme API that takes RangeExpression
    _ = >[0...3, 0...9]
    // Select every ordinal except 6, 7 and 9...
    _ = UIView.self & [+(0...5), +8, +(10...)]
    // ... could alternatively be expressed as
    _ = UIView.self - [6, 7, 9]
    
    // Used for testing:
    // func takesRange<R:RangeExpression>(_ range:R) where R.Bound == Int { }
}
*/
