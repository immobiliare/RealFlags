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

/// Consider `FlagsManager` as an object used to contain all the loaders of feature flag.
/// It's an optional object you can use at your convenience (you can still instantiate and store your own
/// `FlagsLoader` instances without needing of this object).
public class FlagsManager {
    
    // MARK: - Public Properties
    
    /// Default providers for flags loader
    public let providers: [FlagsProvider]
    
    /// Default key configuration.
    public let keyConfiguration: KeyConfiguration
    
    /// Currently loaders.
    public private(set) var loaders = [String: AnyFlagsLoader]()
    
    // MARK: - Initialization
    
    /// Initialize a new flags manager with a specified ordered list of providers and configuration.
    ///
    /// - Parameters:
    ///   - providers: providers to use. This value is used for each new loader created via this manager.
    ///                You can still get values only for certain provider only with the custom methods in `FeatureFlags` instance.
    ///   - keyConfiguration: key configuration.
    public init(providers: [FlagsProvider], keyConfiguration: KeyConfiguration = .init()) {
        self.providers = providers
        self.keyConfiguration = keyConfiguration
    }
    
    // MARK: - Public Functions
    
    /// Load a collection of feature flag and keep inside.
    /// NOTE: If you have already a loader for this kind of data it will be replaced!
    ///
    /// - Parameter type: type of `FlagCollectionProtocol` conform object to instantiate.
    /// - Returns: the relative loader.
    @discardableResult
    public func addCollection<Collection: FlagCollectionProtocol>(_ type: Collection.Type) -> FlagsLoader<Collection> {
        let flagLoader = FlagsLoader(type, providers: providers, keyConfiguration: keyConfiguration)
        let id = String(describing: type)
        loaders[id] = flagLoader
        return flagLoader
    }
    
    /// Remove the loader instance for certain type of object.
    ///
    /// - Parameter type: type of collection.
    public func removeCollection<Collection: FlagCollectionProtocol>(forType type: Collection.Type) {
        let id = String(describing: type)
        loaders.removeValue(forKey: id)
    }
    
    /// Get the loader for certain type of collection.
    ///
    /// - Parameter type: type of collection.
    /// - Returns: FlagsLoader<Collection>
    public func loader<Collection: FlagCollectionProtocol>(forType type: Collection.Type) -> FlagsLoader<Collection>? {
        let id = String(describing: type)
        guard let loader = loaders[id] as? FlagsLoader<Collection> else {
            return nil
        }
        
        return loader
    }
    
}
