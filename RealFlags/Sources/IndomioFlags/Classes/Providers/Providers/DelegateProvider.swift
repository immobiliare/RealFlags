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

// MARK: - DelegateProviderProtocol

public protocol DelegateProviderProtocol: AnyObject {
    
    /// Get the value for a specified key.
    ///
    /// - Parameter key: key
    func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value: FlagProtocol
    
    /// Set value for specified key.
    ///
    /// - Parameters:
    ///   - value: value.
    ///   - key: key.
    func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value: FlagProtocol
    
}

// MARK: - DelegateProvider

public class DelegateProvider: FlagsProvider, Identifiable {
    
    // MARK: - Public Properties
    
    /// Delegate of the messages.
    public weak var delegate: DelegateProviderProtocol?
    
    /// Name of the provider.
    public var name: String
    
    /// Short description of the provider
    public var shortDescription: String? = "Delegate Provider"
    
    /// Supports writable data?
    public var isWritable: Bool = true
    
    // MARK: - Initialization
    
    public init(name: String = UUID().uuidString) {
        self.name = name
    }
    
    // MARK: - Required Methods
    
    public func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value: FlagProtocol {
        delegate?.valueForFlag(key: key)
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value: FlagProtocol {
        guard isWritable else {
            return false
        }
        
        return try delegate?.setValue(value, forFlag: key) ?? false
    }

}
