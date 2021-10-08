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

@propertyWrapper
public struct FlagCollection<Group: FlagCollectionProtocol>: FeatureFlagConfigurableProtocol, Identifiable {
    
    /// All collections must be `Identifiable`
    public let id = UUID()
    
    /// The `FlagContainer` being wrapped.
    public var wrappedValue: Group
    
    /// A metadata object which encapsulate all the additional informations about the group itself.
    public let metadata: FlagMetadata
    
    /// How to compose the key for keypath to a nested property.
    public let keyConfiguration: CollectionKeyPathConfiguration
    
    /// How we should display this group in Vexillographer
    public let uiRepresentation: UIRepresentation
    
    /// Full keypath of the group.
    public var keyPath: FlagKeyPath {
        // swiftlint:disable force_unwrapping
        let currentKeyPath = (fixedKey ?? loader.propertyName,
                              (fixedKey == nil ? loader.instance!.keyConfiguration : KeyConfiguration(keyTransform: .none)))
        let fullPath: [KeyPathAndConfig] = loader.propertyPath + [currentKeyPath]
        return loader.generateKeyPath(fullPath)
    }
    
    // MARK: - Private Properties
    
    /// The loader used to retrive the fetched value for property flags.
    /// This value is assigned when the instance of the Flag is created and it set automatically
    /// by the `configureWithLoader()` function.
    internal private(set) var loader = LoaderBox()
    
    /// Fixed key used to override the default path composing mechanism.
    private var fixedKey: String?
    
    // MARK: - Initialization
    
    /// Initialize a new group of feature flags.
    ///
    /// - Parameters:
    ///   - name: name of the group. You can omit it, it's used only to describe the property.
    ///   - key: fixed key. It's used to compose the full path of the properties. Set a non `nil` value to override the automatic path calculation.
    ///   - keyConfiguration: defines how this property contribute to the full path to a inner property. The default is `.default` which simply ineriths
    ///                       settings from the parent's `FlagLoader`.
    ///   - description: description of the group; you are encouraged to setup it in order to document your feature flags.
    ///   - uiRepresentation: the ui control used to represent the control.
    public init(name: String? = nil,
                key: String? = nil,
                keyConfiguration: CollectionKeyPathConfiguration = .default,
                description: FlagMetadata,
                uiRepresentation: UIRepresentation = .asNavigation) {
        self.fixedKey = key
        self.wrappedValue = Group()
        self.keyConfiguration = keyConfiguration
        self.uiRepresentation = uiRepresentation

        var newMetadata = description
        newMetadata.name = name
        self.metadata = newMetadata
    }
    
    // MARK: - Internal Methods
    
    public func configureWithLoader(_ loader: FlagsLoaderProtocol, propertyName: String, keyPath: [KeyPathAndConfig]) {
        self.loader.instance = loader
        self.loader.propertyPath = keyPath + [(propertyName, keyConfiguration.keyConfiguration(loaderTransform: loader.keyConfiguration.keyTransform))]
        self.loader.propertyName = propertyName
                
        let properties = Mirror(reflecting: wrappedValue).children.lazy.featureFlagsConfigurableProperties()
        for property in properties {
            property.value.configureWithLoader(loader, propertyName: property.label, keyPath: self.loader.propertyPath)
        }
    }
    
}

// MARK: - FlagCollection (Equatable)

extension FlagCollection: Equatable where Group: Equatable {
    
    public static func == (lhs: FlagCollection, rhs: FlagCollection) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
}

// MARK: - FlagCollection (Hashable)

extension FlagCollection: Hashable where Group: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.wrappedValue)
    }
    
}

// MARK: - FlagCollection (UIRepresentation)

public extension FlagCollection {

    /// How to display this group in Vexillographer
    ///
    
    /// This allows the UI which manage the feature flag to know what kind of user interface
    /// we should use to load a group of flags under the `FlagCollection` type.
    ///
    /// - `asNavigation`: the default one, used to show all the data.
    /// - `asSection`: displays this group using a `Section`
    enum UIRepresentation {
        case asNavigation
        case asSection
    }

}

// MARK: - CollectionKeyPathConfiguration

extension FlagCollection {
    
    /// Defines how a nested collection must contribute to the composition of the final path to an inner property.
    /// - `default`: is the default mode which simply inherits the value from the parent's `FlagLoader` instance.
    /// - `kebabCase`: refers to the style of writing in which each space is replaced by a `-` character.
    /// - `snakeCase`: refers to the style of writing in which each space is replaced by a `_` character.
    /// - `skip`: skip the contribution of the collection. It will be not part of the path.
    /// - `custom`: define a fixed key to use as the key of the collection.
    public enum CollectionKeyPathConfiguration {
        case `default`
        case kebabCase
        case snakeCase
        case skip
        case custom(String)
        
        /// Transform a CollectionKeyPathConfiguration a KeyConfiguration.
        /// - Parameter transform: transform.
        /// - Returns: KeyConfiguration
        internal func keyConfiguration(loaderTransform transform: String.Transform) -> KeyConfiguration? {
            switch self {
            case .default:
                return KeyConfiguration(keyTransform: transform)
            case .kebabCase:
                return KeyConfiguration(keyTransform: .kebabCase)
            case .snakeCase:
                return KeyConfiguration(keyTransform: .snakeCase)
            case .skip:
                return nil
            case .custom(let v):
                return KeyConfiguration(keyTransform: .custom(v))
            }
        }
    }
    
}
