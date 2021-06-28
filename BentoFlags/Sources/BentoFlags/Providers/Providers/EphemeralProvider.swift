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

public class EphemeralProvider: FlagProvider, Identifiable {
    
    // MARK: - Public Properties
    
    /// Name of the ephemeral provider
    public let name: String
    
    // MARK: - Internal Properties
    
    private var storage: [String: Any]
    
    // MARK: - Initialization
    
    public init(name: String? = nil, values: [String: Any] = [:]) {
        self.name = "Ephemeral-" + (name ?? UUID().uuidString).lowercased()
        self.storage = values
    }
    
    // MARK: - FlagProvider Conformance
    
    public func valueForFlag<Value>(_ key: String) -> Value? where Value : FlagProtocol {
        storage[key] as? Value
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: String) throws where Value : FlagProtocol {
        guard let value = value else {
            storage.removeValue(forKey: key)
            return
        }
        
        storage.updateValue(value, forKey: key)
    }
    
}
