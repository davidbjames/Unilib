//
//  Optionals.swift
//  Unilib
//
//  Created by David James on 5/31/17.
//  Copyright © 2017 David B James. All rights reserved.
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
    /// Cast an optional to a type or nil
    func `as`<T>(_:T.Type) -> T? {
        return flatMap { $0 as? T }
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
    
}

public extension Optional where Wrapped: Sequence {
    public var unwrap:[Wrapped.Element] {
        switch self {
        case let wrapped? : return Array(wrapped)
        case nil :          return []
        }
    }
}

/// Given an optional boolean, support comparison against
/// a non-optional boolean, where no value == false.
public func == (lhs:Optional<Bool>, rhs:Bool) -> Bool {
    switch lhs {
    case .some(let value) :
        return value == rhs
    case .none :
        return false
    }
}
