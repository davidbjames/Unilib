//
//  Sequence.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017-2021 David B James. All rights reserved.
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

public enum SequenceError : Error {
    case strictZip
}
/// Creates a sequence of pairs built out of two underlying sequences
/// and throws an error if the two sequences are not equal length
public func strictZip<S1, S2>(_ collection1:S1, _ collection2:S2) throws -> Zip2Sequence<S1, S2> where S1:Collection, S2:Collection {
    guard collection1.count == collection2.count else {
        throw SequenceError.strictZip
    }
    return zip(collection1, collection2)
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

