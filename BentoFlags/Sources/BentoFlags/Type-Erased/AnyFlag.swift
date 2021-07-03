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

public protocol AnyFlag {
    
    /// Allowed provider.
    var excludedProviders: [FlagProvider.Type]? { get }
    
    /// Name of the flag
    var name: String { get }
    
    /// Description of the flag.
    var description: String { get }
    
    /// Return the key for flag.
    var keyPath: FlagKeyPath { get }
    
    /// Description of data type represented.
    var readableDataType: String { get }
    
    /// Associated providers.
    var providers: [FlagProvider] { get }
    
    /// Description of the flag.
    var defaultFallbackValue: Any? { get }
        
    /// Return the value of the flag.
    ///
    /// - Parameter providerType: you can specify a particular provider to query; otherwise standard's flag behaviour is applied.
    func getValueForFlag(from providerType: FlagProvider.Type?) -> Any?
    
    /// Get a readable description of the value.
    ///
    /// - Parameter providerType: you can specify a particular provider to query; otherwise standard's flag behaviour is applied.
    func getValueDescriptionForFlag(from providerType: FlagProvider.Type?) -> String
    
    /// Save a value to a provider (if supported).
    ///
    /// - Parameter provider: provider to use.
    func setValueToProvider(_ provider: FlagProvider) throws
    
}

extension Flag: AnyFlag {
    
    public var defaultFallbackValue: Any? {
        defaultValue
    }

    public var providers: [FlagProvider] {
        loader.instance?.providers ?? []
    }
    
    public var readableDataType: String {
        String(describing: type(of: wrappedValue.self))
    }
    
    public func getValueForFlag(from providerType: FlagProvider.Type? = nil) -> Any? {
        flagValue(from: providerType)
    }
    
    public func getValueDescriptionForFlag(from providerType: FlagProvider.Type? = nil) -> String {
        guard let value = getValueForFlag(from: providerType) else {
            return "nil"
        }
        
        return String(describing: value)
    }
    

    public var name: String {
        metadata.name ?? loader.propertyName ?? ""
    }
    
    public var description: String {
        metadata.description
    }
    
    public func setValueToProvider(_ provider: FlagProvider) throws {
        try provider.setValue(self.wrappedValue, forFlag: keyPath)
    }
    
}
