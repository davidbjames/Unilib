//
//  Time.swift
//  Unilib
//
//  Created by David James on 11/1/16.
//  Copyright © 2016-2020 David B James. All rights reserved.
//

import Foundation

/// Delay the excecution of some body of work.
/// This typically pushes execution to the
/// beginning of the next run loop and should
/// not be overly depended on.
/// Passing "nil" will cause the work to be
/// executed immediately. (This is not the same
/// as passing 0.0, which will cause this to
/// be run on the next run loop.)
public func delay(_ delay:TimeInterval? = 0.1, _ closure:@escaping ()->()) {
    if let delay = delay {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    } else {
        closure()
    }
}
