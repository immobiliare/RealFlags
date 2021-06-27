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

/// This a wrapper which represent a single Feature Flag.
/// The type that you wrap with `@Flag` must conform to `FlagValue`.
@propertyWrapper
public struct Flag<Value: FlagValue>: Identifiable, CustomDebugStringConvertible {
    
    // MARK: - Public Properties
    
    /// Unique identifier of the feature flag.
    public var id = UUID()

    /// The default value for this flag; this value is used when no provider can obtain the
    /// value you are requesting. Consider it as a fallback.
    public var defaultValue: Value
    
    /// The value associated with flag; if specified it will be get by reading the value of the provider, otherwise
    /// the `defaultValue` is used instead.
    public var wrappedValue: Value {
        valueInProvider(nil) ?? defaultValue
    }
    
    /// A reference to the `Flag` itself is available as a projected value
    /// so you can access to all associated informations.
    public var projectedValue: Flag<Value> {
        self
    }
    
    /// The string-based key for this `Flag` as calculated during `init`.
    /// This key is sent to the associated provider.
    public var key: String {
        ""
    }
    
    /// Metadata information associated with the flag.
    /// Typically is a way to associated a context to the flag in order to be fully documented.
    public var metadata: FlagMetadata
    
    // MARK: - Private Properties
    
    internal let keyEncoding: KeyEncodingStrategy
    
    // MARK: - Initialization
    
    public init(name: String? = nil,
                keyEncoding: KeyEncodingStrategy = .default,
                defaultValue: Value,
                description: FlagMetadata) {
        
        self.defaultValue = defaultValue
        self.keyEncoding = keyEncoding
        
        var info = description
        info.name = name
        self.metadata = info
    }
    
    public var debugDescription: String {
        "\(key)=\(wrappedValue)"
    }
    
    // MARK: - Internal Functions
    
    func valueInProvider(_ provider: FlagProvider?) -> Value? {
        nil
    }
    
}

// MARK: - Flag (Equatable)

extension Flag: Equatable where Value: Equatable {
    
    public static func ==(lhs: Flag, rhs: Flag) -> Bool {
        return lhs.key == rhs.key && lhs.wrappedValue == rhs.wrappedValue
    }
    
}

// MARK: - Flag (Hashable)

extension Flag: Hashable where Value: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(wrappedValue)
    }
    
}

