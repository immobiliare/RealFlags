//
//  RealFlags
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

public protocol AnyFlag: AnyFlagOrCollection {
    
    /// Allowed provider.
    var excludedProviders: [FlagsProvider.Type]? { get }
    
    /// Name of the flag
    var name: String { get }
    
    /// Is the property locked from Flags Browser.
    var isUILocked: Bool { get }
    
    /// Description of the flag.
    var description: String { get }
    
    /// Return the key for flag.
    var keyPath: FlagKeyPath { get }
    
    /// Description of data type represented.
    var readableDataType: String { get }
    
    /// Data type for flag.
    var dataType: Any.Type { get }
    
    /// Metadata for flag.
    var metadata: FlagMetadata { get }

    /// Associated providers.
    var providers: [FlagsProvider] { get }
    
    /// Description of the flag.
    var defaultFallbackValue: Any? { get }
        
    /// Return the value of the flag.
    ///
    /// - Parameter providerType: you can specify a particular provider to query; otherwise standard's flag behaviour is applied.
    func getValueForFlag(from providerType: FlagsProvider.Type?) -> Any?
    
    /// Get a readable description of the value.
    ///
    /// - Parameter providerType: you can specify a particular provider to query; otherwise standard's flag behaviour is applied.
    func getValueDescriptionForFlag(from providerType: FlagsProvider.Type?) -> (value: String, sourceProvider: FlagsProvider?)
    
    /// Save a value to a provider (if supported).
    ///
    /// - Parameter provider: provider to use.
    func setValueToProvider(_ provider: FlagsProvider) throws
    
}

// MARK: - AnyFlag (Flag Conformance)

extension Flag: AnyFlag {
    
    public var isUILocked: Bool {
        metadata.isLocked
    }
        
    public func hierarchyFeatureFlags() -> [AnyFlagOrCollection] {
        []
    }
    
    public var dataType: Any.Type {
        
        func isOptional(_ instance: Any) -> Bool {
            let mirror = Mirror(reflecting: instance)
            let style = mirror.displayStyle
            return style == .optional
        }
        
        if isOptional(wrappedValue) {
            // swiftlint:disable force_unwrapping
            return wrappedTypeFromOptionalType(type(of: wrappedValue.self))!
        } else {
            return type(of: wrappedValue.self)
        }
    }
    
    public var defaultFallbackValue: Any? {
        defaultValue
    }

    public var providers: [FlagsProvider] {
        loader.instance?.providers ?? []
    }
    
    public var readableDataType: String {
        String(describing: dataType)
    }
    
    public func getValueForFlag(from providerType: FlagsProvider.Type? = nil) -> Any? {
        flagValue(from: providerType).value
    }
    
    public func getValueDescriptionForFlag(from providerType: FlagsProvider.Type? = nil) -> (value: String, sourceProvider: FlagsProvider?) {
        
        let result = flagValue(from: providerType)
        guard let value = result.value else {
            return (readableDefaultFallbackValue, nil)
        }
        
        return (String(describing: value), result.source)
    }
    
    public var name: String {
        metadata.name ?? loader.propertyName
    }
    
    public var description: String {
        metadata.description
    }
    
    public func setValueToProvider(_ provider: FlagsProvider) throws {
        try provider.setValue(self.wrappedValue, forFlag: keyPath)
    }
    
}
