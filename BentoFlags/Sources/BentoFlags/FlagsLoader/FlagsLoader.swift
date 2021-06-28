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

/// `FlagsLoader` is used to fetch data for certain group of feature flags.
/// You will initialize a new loader with a certain type of group and an ordered
/// list of providers to query. Then you can fetch feature flag's values directly
/// by accessing to the relative properties from this instance via dynamic member lookup.
@dynamicMemberLookup
public class FlagsLoader<Collection: FlagCollectionProtocol>: FlagsLoaderProtocol {
    
    // MARK: - Private Properties
    
    /// Collection of feature flag loaded.
    private var loadedCollection: Collection
    
    // MARK: - Public Properties
    
    /// Providers where we'll get the data.
    public var providers: [FlagProvider]?
    
    /// How to build automatically keys for each property of the group.
    public let keyConfiguration: KeyConfiguration
    
    // MARK: - Initialization
    
    /// Initiali
    /// - Parameters:
    ///   - collection: type of collection to load. a new instance is made.
    ///   - providers: providers to use to fetch values. Providers are fetched in order.
    ///   - keysConfiguration: configuration 
    public init (_ collectionType: Collection.Type,
                 providers: [FlagProvider]? = nil,
                 keyConfiguration: KeyConfiguration = .init()) {
        self.loadedCollection = collectionType.init()
        self.providers = providers
        self.keyConfiguration = keyConfiguration
        initializeCollectionObjects()
    }

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
    
    public init(prefix: String? = nil, pathSeparator: String = "/", keyTransform: String.Transform = .snakeCase) {
        self.globalPrefix = prefix
        self.keyTransform = keyTransform
        self.pathSeparator = pathSeparator
    }
    
}
    

