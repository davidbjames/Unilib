//
//  DefaultValidators.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

/// Validator that makes sure a string is not empty
public struct NotEmptyStringValidator : ValidatorFactory  {
    public typealias Input = String
    public static func make() -> CompositeValidator<Input> {
        return CompositeValidator<Input>()
            .add({ $0.hasText ? .success : .error(.isEmptyError) })
    }
}
