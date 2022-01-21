//
//  WeakArray.swift
//  C3
//
//  Created by David James on 2021-11-26.
//  Copyright © 2021 David B James. All rights reserved.
//

import Foundation

/// Generic array wrapper that can hold its
/// reference-based items either weakly or strongly.
protocol CaptureArray : Collection {
    associatedtype T:AnyObject
    associatedtype Wrapper
    var contents:[Wrapper] { get }
    var validItems:[T] { get }
    init(_ contents:[T]?)
    subscript(safe index:Array<Wrapper>.Index) -> T? { get }
    var strongify:StrongArray<T> { get }
    var weakify:WeakArray<T> { get }
}

extension CaptureArray {
    /// Ensure this capture array is a strong array.
    var strongify:StrongArray<T> {
        cast(StrongArray<T>.self)
    }
    /// Ensure this capture array is a weak array.
    var weakify:WeakArray<T> {
        cast(WeakArray<T>.self)
    }
    private func cast<C:CaptureArray>(_:C.Type) -> C where C.T == T {
        C(validItems)
    }
    /// Support `for..in` statements, iterating only
    /// those items which are still allocated.
    func makeIterator() -> Array<T>.Iterator {
        validItems.makeIterator()
    }
    // Indices remain according to original item order,
    // which is what you would expect at the call-site.
    // It's up to the developer to consider how that
    // might affect index-based access.
    var startIndex:Array<Wrapper>.Index {
        contents.startIndex
    }
    var endIndex:Array<Wrapper>.Index {
        contents.endIndex
    }
    func index(after i:Array<Wrapper>.Index) -> Array<Wrapper>.Index {
        contents.index(after:i)
    }
}

// DEV NOTE: This uses structs for WeakBox/WeakArray.
// There is no advantage to using classes and would
// only complicate the call-site. Since WeakBox holds
// the references weakly (no retain count increment)
// making copies of these structs wouldn't change this fact.

/// Box to hold a reference type weakly so
/// that storage doesn't prevent the item
/// from deallocating properly.
struct WeakBox<T:AnyObject> {
    weak var value:T?
    init(_ value:T) {
        self.value = value
    }
}

/// Array of weakly boxed reference-type items
/// to be used when passing arrays into long-lived
/// closures so that those items are not strongly
/// held and may deallocate properly.
struct WeakArray<T:AnyObject> : CaptureArray {
    
    var contents:[WeakBox<T>]
    
    init(_ contents:[T]?) {
        if let contents = contents {
            self.contents = contents.map { WeakBox($0) }
        } else {
            self.contents = []
        }
    }
    
    /// Get the valid, still allocated, items.
    var validItems:[T] {
        contents.compactMap { $0.value }
    }
    /// Cleanup empty boxes where the stored item has been deallocated
    mutating func flush() {
        contents = contents.filter { $0.value.exists }
    }
    /// Get element at index if it exists and is
    /// still allocated, else nil.
    subscript(safe index:Array<WeakBox<T>>.Index) -> T? {
        indices.contains(index) ? contents[index].value : nil
    }
    /// Get element at index.
    ///
    /// In addition to standard crash if index
    /// is not valid, this will also crash if the
    /// boxed item has been deallocated.
    ///
    /// See also `subscript(safe:)`.
    subscript(position:Array<WeakBox<T>>.Index) -> T {
        contents[position].value!
    }
    func `as`<I:AnyObject>(_:I.Type) -> WeakArray<I> {
        WeakArray<I>(validItems.compactMap { $0 as? I })
    }
}

/// Array of reference-type items held strongly.
/// This is meant to be used generically or
/// in-concert with WeakArray.
/// On its own it adds nothing to an Array.
struct StrongArray<T:AnyObject> : CaptureArray {
    var contents:[T]
    var validItems:[T] {
        contents
    }
    init(_ contents:[T]?) {
        self.contents = contents ?? []
    }
    /// Get element at index if it exists and is
    /// still allocated, else nil.
    subscript(safe index:Array<T>.Index) -> T? {
        indices.contains(index) ? contents[index] : nil
    }
    /// Get element at index.
    ///
    /// See also `subscript(safe:)`.
    subscript(position:Array<T>.Index) -> T {
        contents[position]
    }
    func `as`<I:AnyObject>(_:I.Type) -> StrongArray<I> {
        StrongArray<I>(validItems.compactMap { $0 as? I })
    }
}
