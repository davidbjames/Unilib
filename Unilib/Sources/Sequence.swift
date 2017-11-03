//
//  Sequence.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation

public extension Sequence {
    /// Cast a sequence's elements to a type, returning a non-optional
    /// sequence with n to 0 elements depending if the cast succeeds.
    func `as`<T>(_:T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
    /// Cast a sequence to a sequence containing a type, or nil.
    func with<T>(_:T.Type) -> [T]? {
        return self as? [T]
    }
    
    /// Alias to forEach, because it's prettier. Don't bug me. ;)
    func each(_ body: (Element) throws -> Void) rethrows {
        try forEach(body)
    }
}