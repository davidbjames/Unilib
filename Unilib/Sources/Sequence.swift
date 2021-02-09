//
//  Sequence.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017-2020 David B James. All rights reserved.
//

import Foundation

public extension Sequence {
    /// Cast a sequence's elements to a type, returning a non-optional
    /// sequence with n or 0 elements depending if the cast succeeds.
    func `as`<T>(_:T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
    
    /// Cast a sequence to a sequence containing a type, or nil.
    // Commenting this out for now until needed.
    // at which point name it less obscurely.
    // Difference with "as" above is this is a true cast attempt
    // on the entire array of Ts, whereas "as" iterates each
    // item and attempts the cast individually.
    /*
    func with<T>(_:T.Type) -> [T]? {
        return self as? [T]
    }
    */
    
    /// Alias to forEach, because it's prettier. Don't bug me. ;)
    func each(_ body: (Element) throws -> Void) rethrows {
        try forEach(body)
    }
    
}

public extension Sequence where Element : Hashable {
    
    func contains(_ elements: [Element]) -> Bool {
        return Set(elements).isSubset(of:Set(self))
    }
//    func containsAtLeastOne(of elements:[Element]) -> Bool {
//        
//    }
}

// Some ideas that should be materialized for working with
// optional sequences..

//public func += (lhs:Sequence, rhs:Sequence?) -> Sequence {
//
//}

//public extension Optional where Wrapped == Array<Element> {
//    var unwrap:Wrapped {
//        switch self {
//        case .none :
//            return []
//        case .some(let wrapped) :
//            return wrapped
//        }
//    }
//}

