//
//  IndomioFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Immobiliare.it SpA. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

// MARK: - Int

extension Int: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        switch value {
        case .integer(let v):
            self = v
        case .string(let v):
            self = (v as NSString).integerValue
        default:
            return nil
        }
    }

    public func encoded() -> EncodedFlagValue {
        .integer(self)
    }
    
}

// MARK: - Int8

extension Int8: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = Int8(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
}

// MARK: - Int16

extension Int16: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = Int16(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
}

// MARK: - Int32

extension Int32: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = Int32(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
}

// MARK: - Int64

extension Int64: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = Int64(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
    
}

// MARK: - UInt

extension UInt: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = UInt(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
    
}

// MARK: - UInt8

extension UInt8: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = UInt8(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
    
}

// MARK: - UInt16

extension UInt16: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = UInt16(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
    
}

// MARK: - UInt32

extension UInt32: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = UInt32(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
    
}

// MARK: - UInt64

extension UInt64: FlagProtocol {
    public typealias EncodedValue = Int

    public init?(encoded value: EncodedFlagValue) {
        guard let value = Int(encoded: value) else {
            return nil
        }
        
        self = UInt64(value)
    }

    public func encoded() -> EncodedFlagValue {
        .integer(Int(self))
    }
    
}

// MARK: - Double

extension Double: FlagProtocol {
    public typealias EncodedValue = Double

    public init?(encoded value: EncodedFlagValue) {
        switch value {
        case let .double(value):
            self = value
        case let .float(value):
            self = Double(value)
        case let .integer(value):
            self = Double(value)
        case let .string(value):
            self = (value as NSString).doubleValue
        default:
            return nil
        }
    }

    public func encoded() -> EncodedFlagValue {
        .double(self)
    }
    
}

// MARK: - Float

extension Float: FlagProtocol {
    public typealias EncodedValue = Float

    public init?(encoded value: EncodedFlagValue) {
        switch value {
        case .float(let v):
            self = v
        case .double(let v):
            self = Float(v)
        case .integer(let v):
            self = Float(v)
        case .string(let v):
            self = (v as NSString).floatValue
        default:
            return nil
        }
    }

    public func encoded() -> EncodedFlagValue {
        .float(self)
    }
    
}
