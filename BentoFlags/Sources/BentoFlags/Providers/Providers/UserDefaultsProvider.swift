//
//  BentoFlags
//  Easily manage feature flags in Swift.
//
//  Created by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

/// This is one of the built-in providers for feature flags; it stores features flags into the
/// UserDefaults dictionary.
/// Keys are not stored in a tree but locally (the full path is the final key used to store the value).
/// Values are stored as `Data` and all primitives and `Codable` conformant objects are supported.
extension UserDefaults: FlagsProvider {
    
    // MARK: - Public Properties
    
    /// Name of the storage.
    public var name: String {
        "UserDefaults"
    }
    
    /// Short description.
    public var shortDescription: String? {
        guard self == UserDefaults.standard else {
            return String(describing: self)
        }
        
        return "UserDefaults-Standard"
    }
    
    /// Support writing values.
    public var isWritable: Bool {
        true
    }
    
    // MARK: - FlagsProvider Conformance

    public func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value : FlagProtocol {
        guard
            let rawObject = object(forKey: key.fullPath), // attempt to retrive the object from userdefault's apis
            let encodedFlag = EncodedFlagValue(object: rawObject, classType: Value.self) else {
            return nil
        }
        
        return Value(encoded: encodedFlag)
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value : FlagProtocol {
        guard let value = value else {
            // nil object means we want to remove the data from the source
            removeObject(forKey: key.fullPath)
            return true
        }
        
        setValue(value.encoded().nsObject(), forKey: key.fullPath)
        return true
    }
    
}
