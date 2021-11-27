//
//  WeakArray.swift
//  C3
//
//  Created by David James on 2021-11-26.
//  Copyright © 2021 David B James. All rights reserved.
//

import Foundation

/// Box to hold a reference type weakly so
/// that storage doesn't prevent the item
/// from deallocating properly.
public struct WeakBox<T:AnyObject> {
    public weak var value:T?
    public init(_ value:T) {
        self.value = value
    }
}

/// Array of weakly boxed reference-type items
/// to be used when passing arrays into long-lived
/// closures so that those items are not strongly
/// held and may deallocate properly.
public struct WeakArray<T:AnyObject> {
    
    private var contents:[WeakBox<T>]
    
    public init(_ contents:[T]) {
        self.contents = contents.map { WeakBox($0) }
    }
    
    /// Get the valid, still allocated, items.
    public var validItems:[T] {
        contents.compactMap { $0.value }
    }
    /// Cleanup empty boxes where the stored item has been deallocated
    public mutating func flush() {
        contents = contents.filter { $0.value.exists }
    }
    /// Get element at index if it exists and is
    /// still allocated, else nil.
    public subscript(safe index:Index) -> T? {
        indices.contains(index) ? contents[index].value : nil
    }
}

extension WeakArray : Collection {
    /// Support `for..in` statements, iterating only
    /// those items which are still allocated.
    func makeIterator() -> Array<T>.Iterator {
        validItems.makeIterator()
    }
    /// Get element at index.
    ///
    /// In addition to standard crash if index
    /// is not valid, this will also crash if the
    /// boxed item has been deallocated.
    ///
    /// See also `subscript(safe:)`.
    subscript(position:Index) -> T {
        contents[position].value!
    }
    // Indices remain according to original item order,
    // which is what you would expect at the call-site.
    // It's up to the developer to consider how that
    // might affect index-based access.
    typealias Index = Array<T>.Index
    var startIndex:Index {
        contents.startIndex
    }
    var endIndex:Index {
        contents.endIndex
    }
    func index(after i:Index) -> Index {
        contents.index(after:i)
    }
}

