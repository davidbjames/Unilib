//
//  OptionSet.swift
//  Unilib
//
//  Created by David James on 5/23/17.
//  Copyright © 2017-2021 David B James. All rights reserved.
//

import Foundation

public extension SetAlgebra {
    
    /// Replace an item (if it exists in the set) with another item
    /// and return the new set.
    func replacing(_ lhs:Element, with rhs:Element) -> Self {
        var set = self
        set.replace(lhs, with: rhs)
        return set
    }
    
    /// Replace an item (if it exists in the set) with another item.
    mutating func replace(_ lhs:Element, with rhs:Element) {
        guard remove(lhs) != nil else { return }
        insert(rhs)
    }
    
    var hasValues:Bool {
        return !isEmpty
    }

    /// Does the current set intersect another set?
    /// e.g. [.a,.b].intersects([.b,.c]) // true
    func intersects(_ other:Self) -> Bool {
        return !isDisjoint(with:other)
    }
}

public extension Set {
    
    /// Does the current set intersect another?
    func intersects(_ elements:Set<Element>) -> Bool {
        return !isDisjoint(with:elements)
    }
}

