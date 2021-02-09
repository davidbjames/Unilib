//
//  DebugMeta.swift
//  Unilib
//
//  Created by David James on 1/24/17.
//  Copyright © 2017-2020 David B James. All rights reserved.
//

import UIKit

public extension NSObject {
    
    /// Unique memory address
    func memoryAddress(shortened:Bool = false) -> String {
        let address = Unmanaged.passUnretained(self).toOpaque().debugDescription
        guard shortened else { return address }
        // Capture last 4 characters e.g. 2d10
        let startIndex = address.index(address.endIndex, offsetBy: -4)
        let lastIndex = address.endIndex
        let part = String(address[startIndex..<lastIndex]).uppercased()
        // prepend an "x" to distinguish the number as being related
        // to a unique id or memory address e.g. x2d10
        return "x\(part)"
    }
    
    /// Unique object id (hash of memory address)
    func objectId(shortened:Bool = false) -> String {
        let hash = String(describing: ObjectIdentifier(self).hashValue)
        // The full hash looks like this 140522157469520
        // where the first 9 digits tend to be grouped by some
        // mechanism (object type, or creation time?) such that
        // several similar (or sometimes disimilar) objects have
        // these 9 digits as a common prefix. The last 6 digits tend
        // to be unique within groups of objects, and the final 3 the
        // most unique. 140522157-469-520
        if shortened {
            //let first = hash[hash.startIndex...hash.index(after:hash.startIndex)]
            // \(first)/
            let last = hash[hash.index(hash.endIndex, offsetBy: -3)..<hash.endIndex]
            // Prepending the x here is for convention only.
            return "x\(last)"
        }
        return hash
    }
}

