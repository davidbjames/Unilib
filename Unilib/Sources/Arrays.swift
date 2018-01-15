//
//  Arrays.swift
//  Unilib
//
//  Created by David James on 7/14/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

// MARK:- Indexes

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

// MARK:- Find

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

// MARK:- Boolean logic

public extension Sequence where Element : Equatable {
    
    func doesNotContain(_ element:Element) -> Bool {
        return !self.contains(element)
    }
}

public extension Collection {
    
    var nonEmpty:Self? {
        return count > 0 ? self : nil
    }

    func has(_ test:(Iterator.Element)->Bool) -> Bool {
        return self.filter(test).count > 0
    }
    
    func hasAll(_ test:(Iterator.Element)->Bool) -> Bool {
        return self.filter(test).count == self.count
    }

    func hasNot(_ test:(Iterator.Element)->Bool) -> Bool {
        return self.filter(test).count == 0
    }
    
}

// MARK:- Optionals

public extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Sequence where Element : OptionalType {
    
    var droppingNils:[Iterator.Element.Wrapped] {
        return flatMap({ $0.optional })
    }
}

public extension Collection where Element : OptionalType {
    
    var firstNonNil:Element.Wrapped? {
        return first { $0.optional != nil } as? Element.Wrapped
    }
    
    var countOfNonNil:Int {
        return self.filter({ $0.optional != nil }).count
    }
    
    /// One (and only one) item is non-nil
    /// This is roughly an 'xor boolean' function:
    /// if [x,y,z].containsOnlyOneNonNil
    var hasOnlyOneNonNil:Bool {
        return countOfNonNil == 1
    }
    
    var hasNonNil:Bool {
        return countOfNonNil > 0
    }
    
    var allNil:Bool {
        return countOfNonNil == 0
    }
    
    var allNonNil:Bool {
        return countOfNonNil == count
    }
}

// MARK:- Set-like

// Set-like functionality on arrays. Overall, if possible, use Set
// (a Sequence) for set functionality because the performance characteristics 
// are signficantly better than doing similar things with arrays, and this is 
// primarily because Sets use Hashable elements. Exception to this rule would be 
// if you create wrapper functions on arrays that use Sets, such as
// removingDuplicates below. Generally, the key to overall performance is
// making sure that objects are Hashable and use a hashing algorithm that is free 
// from collisions (as collisions cause performance degradation). Also,
// Per some bloke on the internet, the "Equatable ==" implementation should
// guard on this hash for further optimization. (see example below)

/*
struct MyHashable : Hashable {
    let i:Int
    let j:Int
    var hashValue: Int {
        return i.hashValue ^ (j.hashValue &* 987654433)
        // The following vv hash function is 1800% slower than ^^ due to collisions
        // based on worst case scenario: e.g. MyHashable(i:i, j:i+1)
        // return i.hashValue ^ j.hashValue
    }
    public static func == (lhs:MyHashable, rhs:MyHashable) -> Bool {
        // Verify this guard is always a performant choice.
        // Perhaps where equality checks are expensive it's a good idea.
        guard lhs.hashValue == rhs.hashValue else { return false }
        return lhs.i == rhs.i && lhs.j == rhs.j
    }
}
*/


/// Set-like functionality on Array with Hashable elements
/// These have the advantage of using Set logic which performs
/// an order of magnitude better than Array/contains logic 
/// because of working with hashable elements.
/// Peformance on these is O(1)
public extension Array where Iterator.Element: Hashable {
    
    func removingDuplicates() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
    
    /// Insert an element if it does not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union(a) --> [a,b,c]
    func insert(_ element:Element) -> Array<Element> {
        var set = Set(self)
        set.insert(element)
        return Array(set)
    }

    /// Insert or replace an element regardless.
    func update(with element:Element) -> Array<Element> {
        var set = Set(self)
        set.update(with: element)
        return Array(set)
    }

    /// Append an element if it does not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union(a) --> [a,b,c]
    func union(_ element:Element) -> Array<Element> {
        return Array(Set(self).union([element]))
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union([a,d]) --> [a,b,c,d]
    func union(_ elements:[Element]) -> Array<Element> {
        return Array(Set(self).union(elements))
    }
    
    /// Append an element if it does not already exist in the array
    /// Example: [a,b,c].formUnion(a) --> [a,b,c]
    mutating func formUnion(_ element:Element) {
        self = union([element])
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// Example: [a,b,c].formUnion([a,d]) --> [a,b,c,d]
    mutating func formUnion(_ elements:[Element]) {
        self = union(elements)
    }
    
    /// Return array including elements shared in self and provided array.
    /// Example: [a,b,c].intersect([b,c,d]) --> [b,c]
    func intersection(_ elements:[Element]) -> Array<Element> {
        return Array(Set(self).intersection(elements))
    }
    
    /// Mutate array to only include elements shared in self and provided array.
    /// Example: [a,b,b,c].formIntersection([b,c,d]) --> [b,c]
    mutating func formIntersection(_ elements:[Element]) {
        self = intersection(elements)
    }
    
    /// Return array including elements that are not shared
    /// in self and provided array.
    /// a.k.a. exclusiveOr / symmetricDifference
    /// Example: [a,b,c,a].difference([b,b,c,d]) --> [a,d]
    func difference(_ elements:[Element]) -> Array<Element> {
        return Array(Set(self).symmetricDifference(elements))
    }
    
    /// Mutate array to only include elements that are not shared
    /// in self and provided array.
    /// a.k.a. exclusiveOr / symmetricDifference
    /// Example: [a,b,c,a].formDifference([b,b,c,d]) --> [a,d]
    mutating func formDifference(_ elements:[Element]) {
        self = difference(elements)
    }
    
    /// Return array with elements in provided array "subtracted"
    /// from original array.
    /// [a,a,b,c].subtract([b,c,d]) --> [a]
    /// also: [a,a,b,c].subtract([a,b,c,d]) --> []
    func subtract(_ elements:[Element]) -> Array<Element> {
        return Array(Set(self).subtracting(elements))
    }
    
    /// Return array with provided element "subtracted"
    /// from original array.
    /// [a,a,b,c].subtract([b,c,d]) --> [a]
    /// also: [a,a,b,c].subtract([a,b,c,d]) --> []
    func subtract(_ element:Element) -> Array<Element> {
        return subtract([element])
    }
    
    /// Mutate array subtracting provided array from the original array.
    /// [a,a,b,c].formSubtraction([b,c,d]) --> [a]
    /// also: [a,a,b,c].formSubtraction([a,b,c,d]) --> []
    mutating func formSubtraction(_ elements:[Element]) {
        self = subtract(elements)
    }
    
    /// Return array with left-hand-side element replaced
    /// by another element, IF lhs element exists.
    /// [a,b,c].replacing(b, with:d) --> [a,d,c]
    func replacing(_ lElement:Element, with rElement:Element) -> Array<Element> {
        return Array(Set(self).replacing(lElement, with: rElement))
    }
    
    // Comparing:
    
    /// Does the current array intersect another array.
    /// Example: [a,b,c].intersects([c,d]) --> true
    func intersects(_ elements:[Element]) -> Bool {
        return Set(self).intersects(Set(elements))
    }

    /// Is the current array a subset of another array
    /// Example: [a,b].isSubset(of:[a,b,c]) --> true
    /// Also: [a,b].isSubset(of:[a,b]) --> true
    func isSubset(of elements:[Element]) -> Bool {
        return Set(self).isSubset(of: Set(elements))
    }
    
    /// Is the current array a superset of another array
    /// Example: [a,b,c].isSuperset(of:[a,b]) --> true
    /// See also: contains() which does the same thing.
    func isSuperset(of elements:[Element]) -> Bool {
        return Set(self).isSuperset(of: Set(elements))
    }
    
    // add other compares as needed. See SetAlgebra comparison operators.
    
    // TODO ✅ Move things to Sequence where Hashable
    // if possible. contains() is already there.
}


/// Set-like functionality on Arrays Equatable elements.
/// Performance on these is O(n)
public extension Array where Element : Equatable {
    
    func removingDuplicates() -> Array<Iterator.Element> {
        var newArray = [Element]()
        for element in self {
            newArray.formUnion(element)
        }
        return newArray
    }
    
    /// Insert an element if it does not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union(a) --> [a,b,c]
    func insert(_ element:Element) -> Array<Element> {
        var newArray = self
        newArray.formUnion(element)
        return newArray
    }
    
    /// Insert or replace an element regardless.
    func update(with element:Element) -> Array<Element> {
        var newArray = self
        if let index = newArray.index(of: element) {
            newArray[index] = element
        } else {
            newArray.append(element)
        }
        return newArray
    }
    
    /// Append an element if it does not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union(a) --> [a,b,c,d]
    func union(_ element:Element) -> Array<Element> {
        var newArray = self
        newArray.formUnion([element])
        return newArray
    }

    /// Append an array of elements if they do not already exist in the array
    /// and return a new array.
    /// Example: [a,b,c].union([a,d]) --> [a,b,c,d]
    func union(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.formUnion(elements)
        return newArray
    }
    
    /// Append an element if it does not already exist in the array
    /// Example: [a,b,c].formUnion(a) --> [a,b,c]
    mutating func formUnion(_ element:Element) {
        if doesNotContain(element) {
            append(element)
        }
    }
    
    /// Append an array of elements if they do not already exist in the array
    /// Example: [a,b,c].formUnion([a,d]) --> [a,b,c,d]
    mutating func formUnion(_ elements:[Element]) {
        for element in elements {
            formUnion(element)
        }
    }
    
    /// Return array including elements shared in self and provided array.
    /// Example: [a,b,c].intersect([b,c,d]) --> [b,c]
    func intersection(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.formIntersection(elements)
        return newArray
    }
    
    /// Mutate array to only include elements shared in self and provided array.
    /// Example: [a,b,b,c].formIntersection([b,c,d]) --> [b,b,c]
    mutating func formIntersection(_ rElements:[Element]) {
        var result = Array<Element>()
        for lElement in self {
            if rElements.contains(lElement) { // && result.doesNotContain(lElement)
                result.append(lElement)
            }
        }
        self.removeAll()
        self.append(contentsOf: result)
    }
    
    /// Return array including elements that are not shared
    /// in self and provided array.
    /// a.k.a. exclusiveOr / symmetricDifference
    /// Example: [a,b,c,a].difference([b,b,c,d]) --> [a,d]
    func difference(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.formDifference(elements)
        return newArray
    }
    
    /// Mutate array to only include elements that are not shared
    /// in self and provided array.
    /// a.k.a. exclusiveOr / symmetricDifference
    /// As far as ordering is concerned, elements on the left side
    /// come out first and elements on the right side come out last.
    /// Example: [a,b,c,a].formDifference([b,b,c,d]) --> [a,a,d]
    mutating func formDifference(_ rElements:[Element]) {
        var result = Array<Element>()
        
        for lElement in self {
            if rElements.doesNotContain(lElement) { // && result.doesNotContain(lElement)
                result.append(lElement)
            }
        }
        for rElement in rElements {
            if self.doesNotContain(rElement) { // && result.doesNotContain(rElement)
                result.append(rElement)
            }
        }
        self.removeAll()
        self.append(contentsOf: result)
    }
    
    /// Return array with elements in provided array "subtracted"
    /// from original array.
    func subtract(_ elements:[Element]) -> Array<Element> {
        var newArray = self
        newArray.formSubtraction(elements)
        return newArray
    }
    
    /// Return array with provided element "subtracted"
    /// from original array.
    /// [a,a,b,c].subtract([b,c,d]) --> [a]
    /// also: [a,a,b,c].subtract([a,b,c,d]) --> []
    func subtract(_ element:Element) -> Array<Element> {
        return subtract([element])
    }

    /// Mutate array subtracting provided array from the original array.
    /// [a,a,b,c].formDifference([b,c,d]) --> [a,a]
    /// also: [a,a,b,c].formDifference([a,b,c,d]) --> []
    mutating func formSubtraction(_ rElements:[Element]) {
        var result = [Element]()
        for lElement in self {
            if rElements.doesNotContain(lElement) {
                result.append(lElement)
            }
        }
        self.removeAll()
        self.append(contentsOf: result)
    }
    
    /// Return array with left-hand-side element replaced
    /// by another element, IF lhs element exists.
    /// [a,b,c].replacing(b, with:d) --> [a,d,c]
    func replacing(_ lElement:Element, with rElement:Element) -> Array<Element> {
        guard let index = self.index(of: lElement) else {
            return self
        }
        var result = self
        result[index] = rElement
        return result
    }

}


// Randomize array elements
// From Nate Cook: http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift#24029847

public extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

public extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
