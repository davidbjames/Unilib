//
//  NSObject.swift
//  Unilib
//
//  Created by David James on 02/11/2017.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation

// THOUGHT 🕵🏻 Is there a way to simulate protocol conformance where it is
// otherwise impractical (i.e. where message dispatch is required).
// This appears to be necessary with protocols that have associated types
// or self requirements specifically where it is not practical to use these
// protocols via generic constraints. Ideally, you should be able to
// support syntax like: (item as? PatsProtocol)?.doSomething()

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
