//
//  Filters.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

/// Filterer. Returns it's own type (filtered).
public typealias Filter<T> = (T) -> (T)

/// Composite filter. Handles multiple filters via filter().
public class CompositeFilter<T> {
    
    private var filters:[Filter<T>] = []
    
    public init() { }
    
    public func filter(_ input:T) -> T {
        var result:T = input
        for filter in filters {
            result = filter(result)
        }
        return result
    }
    
    public func add(_ filter:@escaping Filter<T>) -> CompositeFilter<T> {
        filters.append(filter)
        return self
    }
    
    public func add(_ factory:CompositeFilter<T>) -> CompositeFilter<T> {
        filters.append(contentsOf: factory.filters)
        return self
    }
    
}

/// Filter factory.
/// Every concrete filter is actually a factory since it primarily
/// produces something that can be used to filter with.
public protocol FilterFactory {
    associatedtype T
    static func make() -> CompositeFilter<T>
}

