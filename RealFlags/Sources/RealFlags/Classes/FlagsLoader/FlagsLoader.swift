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

/// `FlagsLoader` is used to fetch data for certain group of feature flags.
/// You will initialize a new loader with a certain type of group and an ordered
/// list of providers to query. Then you can fetch feature flag's values directly
/// by accessing to the relative properties from this instance via dynamic member lookup.
@dynamicMemberLookup
public class FlagsLoader<Collection: FlagCollectionProtocol>: FlagsLoaderProtocol, CustomDebugStringConvertible {
    
    /// A function which allows to provide a dynamic list of providers for a flag loader.
    public typealias FlagsProviderDynamicCallback = (() -> [FlagsProvider])
    
    // MARK: - Public Properties
    
    /// Collection of feature flag loaded.
    public private(set) var loadedCollection: Collection
    
    /// Providers where we'll get the data.
    public var providers: [FlagsProvider]? {
        if let dynamicProvider = self.dynamicProvidersCallback {
            return dynamicProvider()
        }
        
        return staticProviders
    }
    
    /// How to build automatically keys for each property of the group.
    public let keyConfiguration: KeyConfiguration
    
    /// Metadata associated with loaded flag collection.
    public var metadata: FlagMetadata?
    
    // MARK: - Private Properties
    
    /// Static list of providers if specified.
    /// When a `FlagsProviderDynamicCallback` is passed it will empty.
    private var staticProviders: [FlagsProvider]?
    
    /// Specify a callback function to provide list of dynamic providers.
    private var dynamicProvidersCallback:  FlagsProviderDynamicCallback?
    
    // MARK: - Initialization
    
    /// Initialize a new flags loader collection with static list of providers.
    ///
    /// - Parameters:
    ///   - collection: type of collection to load. a new instance is made.
    ///   - metadata: optional metadata associated with the flag loader.
    ///   - providers: providers to use to fetch values. Providers are fetched in order.
    ///   - keysConfiguration: configuration.
    public init (_ collectionType: Collection.Type,
                 description: FlagMetadata? = nil,
                 providers: [FlagsProvider],
                 keyConfiguration: KeyConfiguration = .init()) {
        self.loadedCollection = collectionType.init()
        self.staticProviders = providers
        self.keyConfiguration = keyConfiguration
        self.metadata = description
        initializeCollectionObjects()
    }
    
    /// Initialize a new flags loader collection with a function which provide providers dynamically.
    ///
    /// - Parameters:
    ///   - collectionType: type of collection to load. a new instance is made.
    ///   - description: optional metadata associated with the flag loader.
    ///   - dynamicProviders: a function which provide a list of providers to use when querying properties from this loader.
    ///   - keyConfiguration: configuratior.
    public init(_ collectionType: Collection.Type,
                description: FlagMetadata? = nil,
                dynamicProviders: FlagsProviderDynamicCallback? = nil,
                keyConfiguration: KeyConfiguration = .init()) {
       self.loadedCollection = collectionType.init()
       self.dynamicProvidersCallback = dynamicProviders
       self.keyConfiguration = keyConfiguration
       self.metadata = description
       initializeCollectionObjects()
   }
    
    // MARK: - Public Functions
    
    public var debugDescription: String {
        return "FlagLoader<\(String(describing: Collection.self))>("
            + Mirror(reflecting: loadedCollection).children
            .map { _, value -> String in
                (value as? CustomDebugStringConvertible)?.debugDescription
                    ?? (value as? CustomStringConvertible)?.description
                    ?? String(describing: value)
            }
            .joined(separator: "; ")
            + ")"
    }
    
    public lazy var featureFlags: [AnyFlag] = {
        return Mirror(reflecting: loadedCollection)
            .children
            .lazy
            .map { $0.value }
            .featureFlags()
    }()
    
    public lazy var hierarcyFeatureFlags: [AnyFlagOrCollection] = {
        return Mirror(reflecting: loadedCollection)
            .children
            .lazy
            .map { $0.value }
            .hierarchyFeatureFlags()
    }()

    // MARK: - dynamicMemberLookup Support
    
    public subscript<Value>(dynamicMember dynamicMember: KeyPath<Collection, Value>) -> Value {
        return loadedCollection[keyPath: dynamicMember]
    }
    
    // MARK: - Private Methods
    
    private func initializeCollectionObjects() {
        let fFlagsProperties = Mirror(reflecting: loadedCollection).children.lazy.featureFlagsConfigurableProperties()
        for property in fFlagsProperties {
            property.value.configureWithLoader(self, propertyName: property.label, keyPath: [])
        }
    }
    
}

// MARK: - KeyConfiguration

public struct KeyConfiguration {
    
    /// Global prefix to append at the beginning of a key.
    public let globalPrefix: String?
    
    /// Transformation to apply for each path component.
    public let keyTransform: String.Transform
    
    /// Path separator, by default is `/`
    public let pathSeparator: String
    
    public init(prefix: String? = nil, pathSeparator: String = FlagKeyPath.DefaultPathSeparator, keyTransform: String.Transform = .snakeCase) {
        self.globalPrefix = prefix
        self.keyTransform = keyTransform
        self.pathSeparator = pathSeparator
    }
    
}
