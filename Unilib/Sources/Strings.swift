//
//  Strings.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016-2021 David B James. All rights reserved.
//

import Foundation

public extension String {
    
    /// Return nil if string is empty
    var value:String? {
        return isEmpty ? nil : self
    }
    /// Return prefix of dot separated string
    var dotPrefix:String? {
        return components(separatedBy: ".").first
    }
    /// Return prefix segments of dot separate string
    func dotPrefix(segments:Int = 1) -> String? {
        return components(separatedBy: ".")
            .prefix(segments).nonEmpty?
            .joined(separator: ".")
    }
    /// Return suffix of dot separate string
    var dotSuffix:String? {
        return components(separatedBy: ".").last
    }
    /// Return suffix segments of dot separate string
    func dotSuffix(segments:Int = 1) -> String? {
        return components(separatedBy: ".")
            .suffix(segments).nonEmpty?
            .joined(separator: ".")
    }

    /// Does the string have length (!empty)
    var hasText:Bool {
        // This method name uses the word "text" for callsite
        // clarity. If using strings for things other than
        // text, make separate methods with appropriate names.
        return !isEmpty
    }
    
    // TODO ✅ Other similar trim() functions
    // trim(to:), trim(_:) (trims string from both sides)
    // leftTrim/rightTrim, etc
    
    func trim(from:String) -> String {
        if let lowerBound = self.range(of: from)?.lowerBound {
            return String(self[..<lowerBound])
        } else {
            return self
        }
    }
    
    /// Get the index of a character in a string.
    func indexDistance(of character: Character) -> Int? {
        guard let index = firstIndex(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }

    /// The "incorrect" way of getting a character
    /// out of a string by integer index.
    /// The Swift team's reasoning for not supporting
    /// this relates to localizable content and
    /// the diversity of how strings can be iterated.
    /// However, there are strict cases where it makes
    /// sense to have a quick and easy accessor by Int
    /// so here it is.
    /// e.g. Quadrant columnLetters "abcd..."
    func character(at _index:Int) -> Character? {
        let i = index(startIndex, offsetBy:_index)
        return self[safe:i]
    }
}

public extension Collection where Element == String {
    
    /// Return all strings with dot prefix segments
    var dotPrefixAll:String {
        return "[" + compactMap { $0.dotPrefix }.joined(separator:",") + "]"
    }
    /// Return all strings with dot prefix segments
    func dotPrefixAll(segments:Int = 1) -> String {
        return "[" + compactMap { $0.dotPrefix(segments:segments) }.joined(separator:",") + "]"
    }
    /// Return all strings with dot suffix segments
    var dotSuffixAll:String {
        return "[" + compactMap { $0.dotSuffix }.joined(separator:",") + "]"
    }
    /// Return all strings with dot suffix segments
    func dotSuffixAll(segments:Int = 1) -> String {
        return "[" + compactMap { $0.dotSuffix(segments:segments) }.joined(separator:",") + "]"
    }
}
