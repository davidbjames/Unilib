//
//  Optionals.swift
//  Unilib
//
//  Created by David James on 5/31/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    var optional:Wrapped? { get }
}

extension Optional : OptionalType {
    public var optional:Wrapped? { return self }
}
