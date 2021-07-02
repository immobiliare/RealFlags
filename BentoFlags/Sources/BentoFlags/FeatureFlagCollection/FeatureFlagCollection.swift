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

@propertyWrapper
public struct FeatureFlagCollection<Group: FlagCollectionProtocol>: FeatureFlagConfigurableProtocol, Identifiable {
    
    /// All collections must be `Identifiable`
    public let id = UUID()
    
    /// The `FlagContainer` being wrapped.
    public var wrappedValue: Group
    
    /// A metadata object which encapsulate all the additional informations about the group itself.
    public let metadata: FlagMetadata
    
    /// How we should display this group in Vexillographer
    public let uiRepresentation: UIRepresentation
    
    /// Full keypath of the group.
    public var keyPath: FlagKeyPath {
        loader.keyPathForProperty(withFixedKey: fixedKey)
    }
    
    // MARK: - Private Properties
    
    /// The loader used to retrive the fetched value for property flags.
    /// This value is assigned when the instance of the Flag is created and it set automatically
    /// by the `configureWithLoader()` function.
    private var loader = LoaderBox()
    
    /// Fixed key used to override the default path composing mechanism.
    private var fixedKey: String?
    
    // MARK: - Initialization
    
    /// Initialize a new group of feature flags.
    ///
    /// - Parameters:
    ///   - name: name of the group. You can omit it, it's used only to describe the property.
    ///   - key: fixed key. It's used to compose the full path of the properties. Set a non `nil` value to override the automatic path calculation.
    ///   - description: description of the group; you are encouraged to setup it in order to document your feature flags.
    ///   - uiRepresentation: the ui control used to represent the control.
    public init(name: String? = nil,
                key: String? = nil,
                description: FlagMetadata,
                uiRepresentation: UIRepresentation = .asNavigation) {
        self.fixedKey = key
        self.wrappedValue = Group()
        self.uiRepresentation = uiRepresentation

        var newMetadata = description
        newMetadata.name = name
        self.metadata = newMetadata
    }
    
    // MARK: - Internal Methods
    
    public func configureWithLoader(_ loader: FlagsLoaderProtocol, propertyName: String, keyPath: [String]) {
        self.loader.instance = loader
        self.loader.propertyPath = keyPath
        self.loader.propertyName = propertyName
        
        let keyPath = self.loader.keyPathForProperty(withFixedKey: fixedKey)
        let properties = Mirror(reflecting: wrappedValue).children.lazy.featureFlagsConfigurableProperties()
        for property in properties {
            property.value.configureWithLoader(loader, propertyName: property.label, keyPath: keyPath.pathComponents)
        }
    }
    
}

// MARK: - FlagCollection (Equatable)

extension FeatureFlagCollection: Equatable where Group: Equatable {
    
    public static func == (lhs: FeatureFlagCollection, rhs: FeatureFlagCollection) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
}

// MARK: - FlagCollection (Hashable)

extension FeatureFlagCollection: Hashable where Group: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.wrappedValue)
    }
    
}


// MARK: - FlagCollection (UIRepresentation)

public extension FeatureFlagCollection {

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
