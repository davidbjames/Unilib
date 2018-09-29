//
//  OptionSet.swift
//  Unilib
//
//  Created by David James on 5/23/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation

public extension SetAlgebra {
    
    /// Replace an item (if it exists in the set) with another item
    /// and return the new set.
    public func replacing(_ lhs:Element, with rhs:Element) -> Self {
        var set = self
        set.replace(lhs, with: rhs)
        return set
    }
    
    /// Replace an item (if it exists in the set) with another item.
    public mutating func replace(_ lhs:Element, with rhs:Element) {
        guard remove(lhs) != nil else { return }
        insert(rhs)
    }
    
    public var hasValues:Bool {
        return !isEmpty
    }
}

public extension Set {
    
    /// Does the current set intersect another?
    func intersects(_ elements:Set<Element>) -> Bool {
        return intersection(elements).count > 0
    }
}

