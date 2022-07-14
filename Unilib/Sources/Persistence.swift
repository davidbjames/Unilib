//
//  Persistence.swift
//  Unilib
//
//  Created by David James on 6/10/22.
//  Copyright © 2022 David B James. All rights reserved.
//

import Foundation

public extension UserDefaults {
    /// Given a Codable type, decode and retreive it from user defaults.
    func codable<T:Codable>(_:T.Type, forKey key:String, debug:Bool = false) -> T? {
        guard let data = object(forKey:key) as? Data else {
            if debug { print("No Codable item of type \(T.self) for key \(key) exists in UserDefaults.") }
            return nil
        }
        do {
            let object = try JSONDecoder().decode(T.self, from:data)
            return object
        } catch {
            if debug { print(error) }
            return nil
        }
    }
    /// Given a Codable type, encode and store it in user defaults.
    func setCodable<T:Codable>(_ object:T, forKey key:String, debug:Bool = false) {
        do {
            let data = try JSONEncoder().encode(object)
            set(data, forKey:key)
        } catch {
            if debug { print(error) }
        }
    }
}
