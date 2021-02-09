//
//  Optionals.swift
//  Unilib
//
//  Created by David James on 5/31/17.
//  Copyright © 2017-2020 David B James. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    var optional:Wrapped? { get }
}

extension Optional : OptionalType {
    public var optional:Wrapped? { return self }
}

public extension Optional {
    
    /// Does this optional have a value?
    var exists:Bool {
        switch self {
        case .some : return true
        case .none : return false
        }
    }
    
    /// Cast an optional to a type or nil
    func `as`<T>(_:T.Type) -> T? {
        return flatMap { $0 as? T }
    }

    /// Convert this optional to an array. If there
    /// is a wrapped element return an array of that
    /// element, otherwise return empty array.
    func toArray() -> [Wrapped] {
        // TODO What if wrapped is an array with items?
        // Would return 2D array. Should we flatten it?
        switch self {
        case .some(let wrapped) :
            return [wrapped]
        case .none :
            return []
        }
    }
    
    // NOTE: Before you're tempted to alias map/flatMap, consider that they
    // are probably the best names at the moment.
    // - map() is good because it maps an optional to something non-nil
    //   (i.e. the closure must return a non-nil value).
    // - flatMap() is not so good. It's still a mapping operation. However,
    //   it can return nil (i.e. in case the mapping is not possible).
    //   The prefix "flat" does not signify this, but I couldn't find
    //   a suitable alternative. So, since map/flatMap are well known terms
    //   of art, perhaps it's better to keep them as-is.
    //   (I tried "wrap" or "unwrap" but neither convey "mapping".)
    // - The problem is, in code, it's not always obvious that the
    //   thing being mapped is an optional (without option clicking it)
    //   so that, at first glance, "map/flatMap" may imply that the
    //   variable is a collection and not an optional.
    //   Something like unwrapAndMap would be more clear.
    
    //   NOTE: Swift 4+ "compactMap" (renamed to avoid confusion) applies only to collections.
    
}

public extension Optional where Wrapped: Sequence {
    var unwrap:[Wrapped.Element] {
        switch self {
        case let wrapped? : return Array(wrapped)
        case nil :          return []
        }
    }
}

// == and != on Optional already exist for comparing
// optionals or optionals and non-optionals

public extension Optional where Wrapped == Bool {
    var isDefault:Bool {
        self == nil
    }
    var isDefaultOrTrue:Bool {
        isDefault || isTrue
    }
    var isTrue:Bool {
        self == true
    }
    var isFalse:Bool {
        self == false
    }
}

// Move the following to it's own file (must make file system changes via Unilib project)

precedencegroup AppendStringPrecedence {
    higherThan   : AdditionPrecedence
    associativity: left
}

infix operator ..? : AppendStringPrecedence

public extension Optional  {
    /// Append string based on an optional value
    /// as returned from closure.
    /// If the value exists, an extra space will
    /// be inserted, otherwise this returns an empty string.
    private func appendString(_ closure:(Wrapped)->String) -> String {
        switch self {
        case let wrapped? : return " " + closure(wrapped)
        case nil : return ""
        }
    }
    /// Append string based on an optional value
    /// as returned from closure.
    /// If the value exists, an extra space will
    /// be inserted, otherwise this returns an empty string.
    static func ..?(lhs:Wrapped?, rhs:(Wrapped) -> String) -> String {
        return lhs.appendString(rhs)
    }
    
    // Why do this? ^^
    // Goal: myString = firstBit + secondOptionalBit?.something
    // Long way:
    // var myString = firstBit
    // if let secondBit = secondOptionalBit {
    //     myString += " " + secondBit.something
    // }
    // Short way:
    // let myString = firstBit + secondOptionalBit ..? { $0.something }
    // .. which is very close to the pseudo code above
}
