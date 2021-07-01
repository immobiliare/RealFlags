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

// MARK: - EncodedFlagValue

/// Defines all the types you can encode/decode as flag value.
/// Custom type you conform to `FlagProtocol` must be able to be represented with one of the following types.
public enum EncodedFlagValue: Equatable {
    case array([EncodedFlagValue])
    case bool(Bool)
    case dictionary([String: EncodedFlagValue])
    case data(Data)
    case double(Double)
    case float(Float)
    case integer(Int)
    case none
    case string(String)
    
    // MARK: - Initialization
    
    /// Create a new encoded data type from a generic object received as init.
    ///
    /// - Parameters:
    ///   - object: object to decode.
    ///   - typeHint: type of data.
    internal init?<Value>(object: Any, classType: Value.Type) where Value: FlagProtocol {
        switch object {
        case let value as Bool where classType.EncodedValue == Bool.self || classType.EncodedValue == Optional<Bool>.self:
            self = .bool(value)
        case let value as Data:
            self = .data(value)
        case let value as Int:
            self = .integer(value)
        case let value as Float:
            self = .float(value)
        case let value as Double:
            self = .double(value)
        case let value as String:
            self = .string(value)
        case is NSNull:
            self = .none
        case let value as [Any]:
            self = .array(value.compactMap({
                EncodedFlagValue(object: $0, classType: classType)
            }))
        case let value as [String: Any]:
            self = .dictionary(value.compactMapValues({
                EncodedFlagValue(object: $0, classType: classType)
            }))
        default:
            return nil
        }
    }
    
    /// Trnsform boxed data in a valid `NSObject` you can store.
    ///
    /// - Returns: NSObject
    internal func nsObject() -> NSObject {
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
