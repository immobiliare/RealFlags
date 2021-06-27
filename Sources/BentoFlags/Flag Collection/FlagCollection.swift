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
public struct FlagCollection<Group: FlagCollectionProtocol>: Identifiable {
    
    /// All collections must be `Identifiable`
    public let id = UUID()
    
    /// The `FlagContainer` being wrapped.
    public var wrappedValue: Group
    
    /// A metadata object which encapsulate all the additional informations about the group itself.
    public let metadata: FlagMetadata
    
    /// How we should display this group in Vexillographer
    public let uiRepresentation: UIRepresentation
    
    // MARK: - Private Properties
    
    /// How to the encode the key.
    private let keyEncoding: FlagKeyEncodingStrategy
    
    // MARK: - Initialization
    
    public init(name: String? = nil,
                keyEncoding: FlagKeyEncodingStrategy = .default,
                description: FlagMetadata,
                uiRepresentation: UIRepresentation = .asNavigation) {
        self.keyEncoding = keyEncoding
        self.wrappedValue = Group()
        self.uiRepresentation = uiRepresentation

        var newMetadata = description
        newMetadata.name = name
        self.metadata = newMetadata
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
