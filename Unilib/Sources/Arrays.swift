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
    func previous(from index:Int) -> Int? {
        if hasPrevious(index) {
            return index - 1
        } else {
            return nil
        }
    }
    
    /// The last index if it exists
    /// (e.g. it would not exist if the provided index is the "last index")
    func next(from index:Int) -> Int? {
        if hasNext(index) {
            return index + 1
        } else {
            return nil
        }
    }
    
    /// Is there a previous index relative to the provided index.
    func hasPrevious(_ index:Int) -> Bool {
        if count == 0 || index == 0 {
            return false
        } else {
            return true
        }
    }
    
    /// Is there a next index relative to the provided index.
    func hasNext(_ index:Int) -> Bool {
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
    /// Example: let foo = myArray.find{ $0.name = "foo"}.element
    func find(_ includeElement: (Iterator.Element) -> Bool) -> (element:Iterator.Element, index:Int, prevIndex:Int?, nextIndex:Int?)? {
        if let element = filter(includeElement).first {
            if let index = index(of: element) {
                return (element, index, previous(from: index), next(from: index))
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
    func union(_ element:Element) -> Array<Element> {
        var newArray = self
        newArray.unionInPlace(element)
        return newArray
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union([a,d]) --> [a,b,c,d]
    func union(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.unionInPlace(elements)
        return newArray
    }
    
    
    /// Append an element if it does not already exist in the array
    /// Example: [a,b,c].unionInPlace(a) --> [a,b,c]
    mutating func unionInPlace(_ element:Element) {
        if !contains(element) {
            append(element)
        }
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// Example: [a,b,c].unionInPlace([a,d]) --> [a,b,c,d]
    mutating func unionInPlace(_ elements:[Element]) {
        for element in elements {
            unionInPlace(element)
        }
    }
    
    /// Intersect array to only include elements shared in self and provided array.
    /// and return a new array.
    /// Example: [a,b,c].intersect([b,c,d]) --> [b,c]
    func intersect(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.intersectInPlace(elements)
        return newArray
    }
    
    /// Mutate array to only include elements shared in self and provided array. (intersection)
    /// Example: [a,b,c].intersectInPlace([b,c,d]) --> [b,c]
    mutating func intersectInPlace(_ elements:[Element]) {
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
    func exclusive(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.exclusiveInPlace(elements)
        return newArray
    }
    
    /// Mutate array to only include elements that are not shared
    /// in self and provided array. (exclusiveOr)
    /// Example: [a,b,c,a].exclusiveInPlace([b,b,c,d]) --> [a,d]
    mutating func exclusiveInPlace(_ elements:[Element]) {
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
