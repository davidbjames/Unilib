//
//  Boolean.swift
//  Unilib
//
//  Created by David James on 2019-11-26.
//  Copyright © 2019 David B James. All rights reserved.
//

import Foundation

public extension Bool {
    /// Toggle the boolean's variable value
    /// and return the new value.
    mutating func toggled() -> Bool {
        toggle()
        return self
    }
}
