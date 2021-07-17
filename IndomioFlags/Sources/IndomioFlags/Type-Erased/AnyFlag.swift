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

public protocol AnyFlag {
    
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

    var dataType: Any.Type { get }

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
    func getValueDescriptionForFlag(from providerType: FlagsProvider.Type?) -> String
    
    /// Save a value to a provider (if supported).
    ///
    /// - Parameter provider: provider to use.
    func setValueToProvider(_ provider: FlagsProvider) throws
    
}

// MARK: - AnyFlag (Flag Conformance)

extension Flag: AnyFlag {
    
    public var dataType: Any.Type {
        
        func isOptional(_ instance: Any) -> Bool {
            let mirror = Mirror(reflecting: instance)
            let style = mirror.displayStyle
            return style == .optional
        }
        
        if isOptional(wrappedValue) {
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
        flagValue(from: providerType)
    }
    
    public func getValueDescriptionForFlag(from providerType: FlagsProvider.Type? = nil) -> String {
        guard let value = getValueForFlag(from: providerType) else {
            return readableDefaultFallbackValue
        }
        
        return String(describing: value)
    }
    
    public var name: String {
        metadata.name ?? loader.propertyName ?? ""
    }
    
    public var description: String {
        metadata.description
    }
    
    public func setValueToProvider(_ provider: FlagsProvider) throws {
        try provider.setValue(self.wrappedValue, forFlag: keyPath)
    }
    
}
