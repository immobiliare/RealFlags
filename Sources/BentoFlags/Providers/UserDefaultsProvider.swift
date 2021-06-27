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
extension UserDefaults: FlagProvider {
    
    public var name: String {
        guard self == UserDefaults.standard else {
            return "UserDefaults-\(String(describing: self))"
        }
        
        return "UserDefaults-Standard"
    }
    
    public func valueForFlag<Value>(_ key: String) -> Value? where Value : FlagProtocol {
        guard
            let rawObject = object(forKey: key), // attempt to retrive the object from userdefault's apis
            let encodedFlag = EncodedFlagValue(object: rawObject, classType: Value.self) else {
            return nil
        }
        
        return Value(encoded: encodedFlag)
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: String) throws where Value : FlagProtocol {
        guard let value = value else {
            // nil object means we want to remove the data from the source
            removeObject(forKey: key)
            return
        }
        
        setValue(value.encoded().nsObject(), forKey: key)
    }
    
}

// MARK: EncodedFlagValue to NSObject

extension EncodedFlagValue {
    
    fileprivate func nsObject() -> NSObject {
        switch self {
        case let .array(value):
            return value.map({ $0.nsObject() }) as NSArray
        case let .bool(value):
            return value as NSNumber
        case let .data(value):
            return value as NSData
        case let .dictionary(value):
            return value.mapValues({ $0.nsObject() }) as NSDictionary
        case let .double(value):
            return value as NSNumber
        case let .float(value):
            return value as NSNumber
        case let .integer(value):
            return value as NSNumber
        case .none:
            return NSNull()
        case let .string(value):
            return value as NSString
        }
    }
    
}
