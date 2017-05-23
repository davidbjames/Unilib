//
//  Strings.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

public extension String {
    /// Does the string have length (!empty)
    var hasText:Bool {
        get {
            return !isEmpty
        }
    }
    
    func trim(from:String) -> String {
        if let lowerBound = range(of: from)?.lowerBound {
            return substring(to: lowerBound)
        } else {
            return self
        }
    }
}
