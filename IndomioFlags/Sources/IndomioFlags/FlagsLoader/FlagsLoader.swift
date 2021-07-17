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

/// `FlagsLoader` is used to fetch data for certain group of feature flags.
/// You will initialize a new loader with a certain type of group and an ordered
/// list of providers to query. Then you can fetch feature flag's values directly
/// by accessing to the relative properties from this instance via dynamic member lookup.
@dynamicMemberLookup
public class FlagsLoader<Collection: FlagCollectionProtocol>: FlagsLoaderProtocol, CustomDebugStringConvertible {
    
    // MARK: - Public Properties
    
    /// Collection of feature flag loaded.
    public private(set) var loadedCollection: Collection
    
    /// Providers where we'll get the data.
    public var providers: [FlagsProvider]?
    
    /// How to build automatically keys for each property of the group.
    public let keyConfiguration: KeyConfiguration
    
    // MARK: - Initialization
    
    /// Initiali
    /// - Parameters:
    ///   - collection: type of collection to load. a new instance is made.
    ///   - providers: providers to use to fetch values. Providers are fetched in order.
    ///   - keysConfiguration: configuration 
    public init (_ collectionType: Collection.Type,
                 providers: [FlagsProvider]? = nil,
                 keyConfiguration: KeyConfiguration = .init()) {
        self.loadedCollection = collectionType.init()
        self.providers = providers
        self.keyConfiguration = keyConfiguration
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
