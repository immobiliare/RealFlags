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
public struct FlagCollection<Group: FlagCollectionProtocol>: FeatureFlagConfigurableProtocol, Identifiable {
    
    /// All collections must be `Identifiable`
    public let id = UUID()
    
    /// The `FlagContainer` being wrapped.
    public var wrappedValue: Group
    
    /// A metadata object which encapsulate all the additional informations about the group itself.
    public let metadata: FlagMetadata
    
    /// How we should display this group in Vexillographer
    public let uiRepresentation: UIRepresentation
    
    // MARK: - Private Properties
    
    /// The loader used to retrive the fetched value for property flags.
    /// This value is assigned when the instance of the Flag is created and it set automatically
    /// by the `configureWithLoader()` function.
    private var loader = LoaderBox()
    
    private var key: String {
        let pathSeparator = loader.instance?.keyConfiguration.pathSeparator ?? "/"
        return loader.fullKeyPathForProperty(fixedKey: fixedKey).joined(separator: pathSeparator)
    }
    
    private var fixedKey: String?
    
    // MARK: - Initialization
    
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
    
    // MARK: - Private Methods
    
    public func configureWithLoader(_ loader: FlagsLoaderProtocol, propertyName: String, keyPath: [String]) {
        self.loader.instance = loader
        self.loader.propertyPath = keyPath
        self.loader.propertyName = propertyName
        
        let fullPathComponents = self.loader.fullKeyPathForProperty(fixedKey: fixedKey)
        let properties = Mirror(reflecting: wrappedValue).children.lazy.featureFlagsConfigurableProperties()
        for property in properties {
            property.value.configureWithLoader(loader, propertyName: property.label, keyPath: fullPathComponents)
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
