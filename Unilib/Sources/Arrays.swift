//
//  Arrays.swift
//  Unilib
//
//  Created by David James on 7/14/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

public extension Array  {
    
    /// The last index of the array if it exists
    var lastIndex:Int? {
        return count > 0 ? count - 1 : nil
        // NOTE: This is different than the non-optional Array.endIndex
        // which returns the "past the end" position.
    }
    
    /// The previous index if it exists
    /// (e.g. it would not exist if the provided index is 0)
    func previousIndex(from index:Int) -> Int? {
        if hasPreviousIndex(from: index) {
            return index - 1
        } else {
            return nil
        }
    }
    
    /// The last index if it exists
    /// (e.g. it would not exist if the provided index is the "last index")
    func nextIndex(from index:Int) -> Int? {
        if hasNextIndex(from: index) {
            return index + 1
        } else {
            return nil
        }
    }
    
    /// Is there a previous index relative to the provided index.
    func hasPreviousIndex(from index:Int) -> Bool {
        if count == 0 || index == 0 {
            return false
        } else {
            return true
        }
    }
    
    /// Is there a next index relative to the provided index.
    func hasNextIndex(from index:Int) -> Bool {
        if count == 0 || index == count - 1 {
            return false
        } else {
            return true
        }
    }
    
    /// Does the array contain the provided index.
    func hasIndex(_ index:Int) -> Bool {
        if count == 0 || index < 0 || index >= count {
            return false
        } else {
            return true
        }
    }
}

/// Search/replace
public extension Array where Element : Equatable {
    
    /// Find the first element that satisfies predicate.
    /// Returns a tuple with element, index and previous/next if they exist.
    ///
    /// - Example: let foo = myArray.find{ $0.name = "foo"}.element
    /// - SeeAlso: Sequence.first(:where) which just returns the element.
    func find(_ includeElement: (Iterator.Element) -> Bool) -> (element:Iterator.Element, index:Int, prevIndex:Int?, nextIndex:Int?)? {
        if let element = self.filter(includeElement).first {
            if let index = self.index(of: element) {
                return (element, index, previousIndex(from: index), nextIndex(from: index))
            }
        }
        return nil
    }
}

/// Set-like functionality on Array
public extension Array where Element : Equatable {
    
    /// Append an element if it does not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union(a) --> [a,b,c]
    func formUnion(_ element:Element) -> Array<Element> {
        var newArray = self
        newArray.union(element)
        return newArray
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union([a,d]) --> [a,b,c,d]
    func formUnion(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.union(elements)
        return newArray
    }
    
    
    /// Append an element if it does not already exist in the array
    /// Example: [a,b,c].unionInPlace(a) --> [a,b,c]
    mutating func union(_ element:Element) {
        if !contains(element) {
            append(element)
        }
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// Example: [a,b,c].unionInPlace([a,d]) --> [a,b,c,d]
    mutating func union(_ elements:[Element]) {
        for element in elements {
            union(element)
        }
    }
    
    /// Intersect array to only include elements shared in self and provided array.
    /// and return a new array.
    /// Example: [a,b,c].intersect([b,c,d]) --> [b,c]
    func formIntersection(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.intersect(elements)
        return newArray
    }
    
    /// Mutate array to only include elements shared in self and provided array. (intersection)
    /// Example: [a,b,c].intersectInPlace([b,c,d]) --> [b,c]
    mutating func intersect(_ elements:[Element]) {
        var result = Array<Element>()
        for element in self {
            if elements.contains(element) && !result.contains(element) {
                result.append(element)
            }
        }
        self.removeAll()
        self.append(contentsOf: result)
    }
    
    /// Mutate array to only include elements that are not shared
    /// in self and provided array and return new array. (exclusiveOr)
    /// Example: [a,b,c,a].exclusive([b,b,c,d]) --> [a,d]
    func formDifference(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.difference(elements)
        return newArray
    }
    
    /// Mutate array to only include elements that are not shared
    /// in self and provided array. (exclusiveOr)
    /// Example: [a,b,c,a].exclusiveInPlace([b,b,c,d]) --> [a,d]
    mutating func difference(_ elements:[Element]) {
        var result = Array<Element>()
        for element in self {
            if !elements.contains(element) && !result.contains(element) {
                result.append(element)
            }
        }
        for element in elements {
            if !self.contains(element) && !result.contains(element) {
                result.append(element)
            }
        }
        self.removeAll()
        self.append(contentsOf: result)
    }
    
    
}