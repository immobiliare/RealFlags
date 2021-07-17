//
//  IndomioFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

// MARK: - Boolean Type

extension Bool: FlagProtocol {
    public typealias EncodedValue = Bool

    public init?(encoded value: EncodedFlagValue) {
        switch value {
        case .bool(let v):
            self = v
        case .integer(let v):
            self = (v != 0)
        case .string(let v):
            self = (v as NSString).boolValue
        default:
            return nil
        }
    }
    
    public func encoded() -> EncodedFlagValue {
        .bool(self)
    }
    
}

// MARK: - String Type

extension String: FlagProtocol {
    public typealias EncodedValue = String

    public init?(encoded value: EncodedFlagValue) {
        guard case .string(let value) = value else {
            return nil
        }
        
        self = value
    }

    public func encoded() -> EncodedFlagValue {
        .string(self)
    }

}

// MARK: - Data Type

extension Data: FlagProtocol {
    public typealias EncodedValue = Data

    public init?(encoded value: EncodedFlagValue) {
        guard case .data(let value) = value else {
            return nil
        }
        
        self = value
    }

    public func encoded() -> EncodedFlagValue {
        .data(self)
    }
    
}

// MARK: - RawRepresentable

extension RawRepresentable where Self: FlagProtocol, RawValue: FlagProtocol {
    public typealias EncodedValue = RawValue.EncodedValue

    public init?(encoded value: EncodedFlagValue) {
        guard let rawValue = RawValue(encoded: value) else {
            return nil
        }
        
        self.init(rawValue: rawValue)
    }

    public func encoded() -> EncodedFlagValue {
        self.rawValue.encoded()
    }
    
}

// MARK: - Optional

extension Optional: FlagProtocol where Wrapped: FlagProtocol {
    public typealias EncodedValue = Wrapped.EncodedValue?

    public init?(encoded value: EncodedFlagValue) {
        if case .none = value {
            self = .none
        } else if let wrapped = Wrapped(encoded: value) {
            self = wrapped
        } else {
            self = .none
        }
    }

    public func encoded() -> EncodedFlagValue {
        self?.encoded() ?? .none
    }
    
}
