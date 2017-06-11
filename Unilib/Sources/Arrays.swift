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

public extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK:- Arrays of Optionals

public extension Sequence where Iterator.Element: OptionalType {
    var droppingNils:[Iterator.Element.Wrapped] {
        return flatMap({ $0.optional })
    }
}

public extension Array where Iterator.Element : OptionalType {
    
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

/// Nil-coalesce array
/// Take the first non-nil value, or if none, the default.
public func ?? <T>(array:Array<T?>, defaultValue:T) -> T {
    return array.droppingNils.first ?? defaultValue
}


// Set-like functionality on arrays. Overall, if possible, use Set
// (a Sequence) for set functionality because the performance characteristics 
// are signficantly better than doing similar things with arrays, and this is 
// primarily because Sets use Hashable elements. Exception to this rule would be 
// if you create wrapper functions on arrays that use Sets, such as
// removingDuplicates below. Generally, the key to overall performance is
// making sure that objects are Hashable and use a hashing algorithm that is free 
// from collisions (as collisions cause performance degradation). Also,
// Equatable == implementation should guard on this hash for further optimization.
// (though this needs more empirical evidence)

/*
struct MyHashable : Hashable {
    let i:Int
    let j:Int
    var hashValue: Int {
        return i.hashValue ^ (j.hashValue &* 987654433)
        // The following hash function is 1800% slower due to collisions 
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
}


/// Set-like functionality on Arrays Equatable elements.
/// Performance on these is O(n)
public extension Array where Element : Equatable {

    func removingDuplicates() -> Array<Iterator.Element> {
        var newArray = [Element]()
        for element in self {
            newArray.union(element)
        }
        return newArray
    }
    
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
