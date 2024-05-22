//
//  UserDefaults.swift
//
//
//  Created by David James on 03/04/2024.
//

import Foundation
import Combine

// MARK: - DefaultsValue

@propertyWrapper
public struct DefaultsValue<T: DefaultsValueType>: Equatable {
    
    private let key: String
    
    public var wrappedValue: T {
        get {
            Self.getValue(for: key, defaultValue: projectedValue.value)
        }
        set {
            setValue(for: key, newValue: newValue)
        }
    }
    private(set) public var projectedValue: CurrentValueSubject<T, Never>
    
    public init(wrappedValue defaultValue: T, _ key: String) {
        self.key = key
        self.projectedValue = CurrentValueSubject(
            Self.getValue(for: key, defaultValue: defaultValue)
        )
        // Do not set wrapped value here, because then you would be
        // storing the default value (and setting the "isSet" flag)
        // before the user has explicitly set the value.
        // Also, wrappedValue is a computed property that is stored elsewhere
        // (i.e. it doesn't need an immediate initialization value).
        // self.wrappedValue = defaultValue
    }
    
    /// Get UserDefaults value if it's been set by the user
    /// otherwise use default value.
    private static func getValue(for key: String, defaultValue: T) -> T {
        if
            UserDefaults.standard.bool(forKey: key + "isSet"),
            let existing = T.getValue(forKey: key)
        {
            return existing
        } else {
            return defaultValue
        }
    }
    
    /// Set value on UserDefaults and flag that it's been set by the user.
    ///
    /// We have to use a flagging system because "Boolean" returns false
    /// by default rather than nil.
    private func setValue(for key: String, newValue: T) {
        newValue.setValue(forKey: key)
        projectedValue.value = newValue
        UserDefaults.standard.setValue(true, forKey: key + "isSet")
    }
    
    public static func == (lhs: DefaultsValue<T>, rhs: DefaultsValue<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension DefaultsValue: CustomStringConvertible {
    public var description: String {
        "DefaultsValue(\(key): \(projectedValue.value))"
    }
}

// MARK: - DefaultsValueType

public protocol DefaultsValueType: Equatable {
    func setValue(forKey key: String)
    static func getValue(forKey key: String) -> Self?
}

extension DefaultsValueType {
    public func setValue(forKey key: String) {
        UserDefaults.standard.set(self, forKey: key)
    }
}

extension Bool: DefaultsValueType {
    public static func getValue(forKey key: String) -> Self? {
        UserDefaults.standard.bool(forKey: key)
    }
}

extension String: DefaultsValueType {
    public static func getValue(forKey key: String) -> Self? {
        UserDefaults.standard.string(forKey: key)
    }
}

// TODO: extensions for other default values types
