//
//  Validators.swift
//  Unilib
//
//  Created by David James on 9/28/16.
//  Copyright © 2016 David B James. All rights reserved.
//

import Foundation

// MOVE out of Unilib unless C3 becomes related to form input and validation.

/**
 Validator / CompositeValidator / ValidatorFactory
 
 There are several approaches to defining a validator:
 1. Implement a ValidatorFactory, and in the make() method:
    a. Use add(Validator) to add custom validation callbacks.
    b. Use add(Factory) to add a ready-made factory or custom factory.
    c. Any combination of the above.
 2. Create a CompositeValidator (of a generic type, like String)
    and add as many validator callbacks as you need.
 3. Grab a ready-made factory and tack on further validators inline.
 4. etc.
 
 Validators are fired in the order added and fail with the first error encountered if any.
*/


/// Validation Error
public enum ValidationError : LocalizedError, Equatable {
    case isEmptyError
    case invalidFormat(String)
}

/// Equatable overload
/// Note: for every case added above you must add to this vvv
public func == (lhs:ValidationError, rhs:ValidationError) -> Bool {
    switch (lhs, rhs) {
    case (.isEmptyError, .isEmptyError) :
        return true
    case (let .invalidFormat(message1), let .invalidFormat(message2)) :
        return message1 == message2
    default :
        return false
    }
}

/// Validation Result: success or error
public enum ValidationResult : Equatable {
    case success
    // .validating should only be used in case of asynchronous validation
    case validating
    case error(ValidationError)
    
    /// The minimum validation result for a collection of
    /// validation results. Based on the idea of "fail early"
    /// If 1 of the results is an "error", return that error.
    /// If 1 of the results is "validating", return that state.
    /// Else return "success".
    public static func reduce(_ results:[ValidationResult]) -> ValidationResult {
        if let error = results.find({ (result:ValidationResult) -> Bool in
            if case .error(_) = result { return true }
            else { return false }
        }) {
            return error.element
        }
        
        if let validating = results.find({ $0 == .validating }) {
            return validating.element
        }
        return .success
    }
}

/// Equatable overload
public func == (lhs:ValidationResult, rhs:ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success) :
        return true
    case (.validating, .validating) :
        return true
    case (let .error(message1), let .error(message2)) :
        return message1 == message2
    default :
        return false
    }
}

/// Convenience helpers for ValidationResult
public extension ValidationResult {
    /// Is the validation considered valid?
    var isValid:Bool {
        switch self {
        case .success :
            return true
        default :
            return false
        }
    }
}


/// Validator function
public typealias Validator<Input> = (Input) -> ValidationResult

/// Composite validator
/// Handles one or many validation per input type
public class CompositeValidator<Input> {
    
    private var validators:[Validator<Input>] = []
    
    public init() { }
    
    // TODO: support server side (asynchronous) validation ".validating"
    // In which case, this may need Rx'ifying.
    // See also ActivityTracker, but note that has RxCocoa dependency.
    // See also ValidationPresenter in Uniview if applicable.
    
    public func validate(_ input:Input) -> ValidationResult {
        for validator in validators {
            let result = validator(input)
            if case .error(_) = result {
                // fail early
                return result
            }
        }
        return ValidationResult.success
    }
    
    public func add(_ validator:@escaping Validator<Input>) -> CompositeValidator<Input> {
        // appending is safe because Input type will always be
        // the same even for composite validations
        validators.append(validator)
        return self
    }
    
    public func add(_ factory: CompositeValidator<Input>) -> CompositeValidator<Input> {
        // appending is safe because Input type will always be
        // the same even for composite validations
        validators.append(contentsOf: factory.validators)
        return self
    }
}

/// Validator Factory
/// Every concrete validator is actually a factory
/// since it primarily produces something that can be validated against.
public protocol ValidatorFactory {
    associatedtype Input
    static func make() -> CompositeValidator<Input>
}

