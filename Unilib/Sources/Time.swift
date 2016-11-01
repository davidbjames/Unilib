//
//  Time.swift
//  Unilib
//
//  Created by David James on 11/1/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

func delay(_ delay:Double = 0.1, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
