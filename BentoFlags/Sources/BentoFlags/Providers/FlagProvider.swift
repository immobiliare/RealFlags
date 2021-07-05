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

#if !os(Linux)
import Combine
#endif

// MARK: - FlagProvider

/// This protocol defines a provider for feature flag values; you can implement your own sources both local or remote ones.
/// Take a look to BentoFlag's built-in provider sources to get an insight of what you can accomplish.
public protocol FlagProvider {
    
    /// Visible name of the flag's source.
    /// It will be used when you need to show the source in some UI.
    var name: String { get }
    
    /// Short description of the object used into the UI.
    var shortDescription: String? { get }
    
    /// Return `true` if provider support overwriting values via `setValue()` function.
    /// Some local providers may support overrides, some remotes may not.
    var isWritable: Bool { get }
    
    /// Fetch value for a specific flag.
    ///
    /// - Parameter key: key of the flag to retrive.
    func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value: FlagProtocol
    
    /// Store a new value for a flag value.
    ///
    /// - Parameters:
    ///   - value: value to set; `nil` value is set to clear any previously set value for given key.
    ///   - key: keypath to set.
    @discardableResult
    func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value: FlagProtocol
        
    #if !os(Linux)
    // Apple platform also support Combine framework to provide realtime notification of new events to any subscriber.
    // By default it does nothing (take a look to the default implementation in extension below).
    
    /// You can use this value to receive updates when keys did updated in sources.
    ///
    /// - Parameter keys: updated keys; may be `nil` if your provider does not support this kind of granularity.
    func didUpdateValuesForKeys(_ keys: Set<String>?) -> AnyPublisher<Set<String>, Never>?
    
    #endif
    
}

// MARK: - FlagProvider (Default Publisher Behaviour)

#if !os(Linux)

/// Make support for real-time flag updates optional by providing a default nil implementation
///
public extension FlagProvider {
    
    func didUpdateValuesForKeys(_ keys: Set<String>?) -> AnyPublisher<Set<String>, Never>? {
        nil
    }

}

#endif
