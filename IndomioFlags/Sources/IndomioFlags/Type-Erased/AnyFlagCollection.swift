//
//  IndomioFlags
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

public protocol AnyFlagCollection: AnyFlagOrCollection {
    
    /// Return the list of all feature flags of the collection.
    func featureFlags() -> [AnyFlag]
    
    /// Name of the collection.
    var name: String { get }
    
    /// Description of the flag collection.
    var description: String { get }
    
}

extension FlagCollection: AnyFlagCollection {
    
    public var name: String {
        metadata.name ?? loader.propertyName ?? ""
    }
    
    public var description: String {
        metadata.description
    }

    public func featureFlags () -> [AnyFlag] {
        Mirror(reflecting: wrappedValue)
            .children
            .lazy
            .map { $0.value }
            .compactMap { element -> [AnyFlag]? in
                if let flag = element as? AnyFlag {
                    return [flag]
                } else if let group = element as? AnyFlagCollection {
                    return group.featureFlags()
                } else {
                    return nil
                }
            }
            .flatMap { $0 }
    }
    
    public func hierarchyFeatureFlags() -> [AnyFlagOrCollection] {
        Mirror(reflecting: wrappedValue)
            .children
            .lazy
            .map { $0.value }
            .compactMap { element -> [AnyFlagOrCollection]? in
                if let flag = element as? AnyFlag {
                    return [flag]
                } else if let group = element as? AnyFlagCollection {
                    return group.hierarchyFeatureFlags()
                } else {
                    return nil
                }
            }
            .flatMap { $0 }
    }
    
}

internal extension Sequence {
    
    func hierarchyFeatureFlags() -> [AnyFlagOrCollection] {
        self.compactMap { element -> [AnyFlagOrCollection]? in
            if let flag = element as? AnyFlag {
                return [flag]
            } else if let group = element as? AnyFlagCollection {
                return [group]
            } else {
                return nil
            }
        }
        .flatMap { $0 }
    }
    
    func featureFlags() -> [AnyFlag] {
        self.compactMap { element -> [AnyFlag]? in
            if let flag = element as? AnyFlag {
                return [flag]
            } else if let group = element as? AnyFlagCollection {
                return group.featureFlags()
            } else {
                return nil
            }
        }
        .flatMap { $0 }
    }
    
}
