//
//  DefaultFilters.swift
//  Unilib
//
//  Created by David James on 9/29/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

/// Turn a string into uppercase letters respecting locale
public struct UppercaseFilter : FilterFactory {
    public typealias T = String
    public static func make() -> CompositeFilter<String> {
        return CompositeFilter<T>()
            .add({ input in
                return input.uppercased(with: Locale.current)
            })
    }
}

/// Turn a string into lowercase letters respecting locale
public struct LowercaseFilter : FilterFactory {
    public typealias T = String
    public static func make() -> CompositeFilter<String> {
        return CompositeFilter<T>()
            .add({ input in
                return input.lowercased(with: Locale.current)
            })
    }
}

/// This filter trims all whitespace from both ends of a string
/// and reduces any internal whitespace to one space
/// e.g. "   Test    foo \t\n  " becomes "Test foo"
public struct RemoveExcessWhitespaceFilter : FilterFactory {
    public typealias T = String
    public static func make() -> CompositeFilter<String> {
        return CompositeFilter<T>()
            .add({ input in
                let components = input.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
                return components.joined(separator: " ")
            })
    }
}
