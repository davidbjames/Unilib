//
//  Strings.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

public extension String {
    
    /// Return nil if string is empty
    var value:String? {
        return isEmpty ? nil : self
    }
    var dotPrefix:String? {
        return components(separatedBy: ".").first
    }
    var dotSuffix:String? {
        return components(separatedBy: ".").last
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
}
