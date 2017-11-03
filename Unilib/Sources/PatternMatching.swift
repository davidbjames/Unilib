//
//  PatternMatching.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation


/// Wrapper to perform pattern matching via closure.
/// Author: Olivier Halligon
public struct Matcher<T> {
    public let closure: (T) -> Bool
    public static func ~= (lhs: Matcher<T>, rhs: T) -> Bool {
        return lhs.closure(rhs)
    }
}

/// Perform a pattern match via closure.
/// Closure must return if a sample (of T) matches a source (of T)
/// which would normally be provided via switch or case statements.
public func match<T>(closure: @escaping (T) -> Bool) -> Matcher<T> {
    return Matcher(closure: closure)
}

/// Check if string contains a substring using pattern matching.
/// This can be used in a switch statement, like:
/// case contains("foo") : ..
/// moreOrLess can be used to perform a fuzzy match
/// that disregards case and diacritic marks.
public func contains(_ string: String, moreOrLess:Bool = false) -> Matcher<String> {
    return Matcher {
        if moreOrLess {
            return string.compare($0, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        } else {
            return $0.contains(string)
        }
    }
}

/// Check if a Set contains a subset.
/// This can be used in a switch statement to check for containment
/// rather than strict equality, e.g.:
/// case contains([.foo, .bar]) // will match even if also contains .baz.
public func contains<T>(_ subset: Set<T>) -> Matcher<Set<T>> {
    return Matcher {
        subset.isSubset(of: $0)
    }
}

/// Check if a Set contains a subset.
/// This can be used in a switch statement to check for containment
/// rather than strict equality, e.g.:
/// case contains(.foo, .bar) // will match even if also contains .baz.
public func contains<T>(_ items:T...) -> Matcher<Set<T>> {
    return Matcher {
        let subset = Set(items)
        return subset.isSubset(of: $0)
    }
}

/// Check if a Sequence contains a particular element.
/// This can be used in a switch statement to check for containment
/// rather than strict equality, e.g.:
/// case contains(1) // will match in an array of [1,2,3]
public func contains<S: Sequence>(_ item: S.Element) -> Matcher<S> where S.Element: Comparable {
    return Matcher {
        $0.contains(item)
    }
}

/// Check if a Sequence contains a particular set of elements.
/// This can be used in a switch statement to check for containment
/// rather than strict equality, e.g.:
/// case contains([1,2,3) // will match in an array of [1,2,3,4]
public func contains<S: Sequence>(_ items: [S.Element]) -> Matcher<S> where S.Element: Hashable {
    return Matcher {
        let source = Set($0)
        let sample = Set(items)
        return sample.isSubset(of: source)
    }
}


