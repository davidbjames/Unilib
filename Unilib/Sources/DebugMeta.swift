//
//  UIView+Helpers.swift
//  ViewQuery
//
//  Created by David James on 1/24/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import UIKit

public extension NSObject {
    
    public func memoryAddress(shortened:Bool = false) -> String {
        let address = String(describing:Unmanaged.passUnretained(self).toOpaque())
        if shortened {
            
            // Following kept for learning. Better way below.
            // Remove "0x0000"
            // let startIndex = address.index(address.startIndex, offsetBy: 6)
            // let prefixRemoved = address.substring(from: startIndex)
            // Capture last 4 characters
            // let lastIndex = prefixRemoved.index(prefixRemoved.endIndex, offsetBy: -4)
            // let addressPart = prefixRemoved.substring(from: lastIndex)
            
            // Capture the last 4 characters.
            let startIndex = address.index(address.endIndex, offsetBy: -4)
            let addressPart = address[startIndex..<address.endIndex]
            
            return "x\(addressPart)"
        }
        return address
    }
}

