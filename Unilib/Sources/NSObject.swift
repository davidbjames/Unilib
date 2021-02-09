//
//  NSObject.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017-2021 David B James. All rights reserved.
//

import Foundation

public extension NSObject {
    /// Perform a selector safely by making sure the current
    /// object can respond to the selector
    func performSafely(_ selector:String, _ input:Any? = nil) {
        guard responds(to: Selector((selector))) else {
            return
        }
        perform(Selector((selector)), with: input)
    }
}
