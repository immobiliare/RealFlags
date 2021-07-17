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

public protocol AnyFlagCollection {
    
    /// Return the list of all feature flags of the collection.
    func featureFlags() -> [AnyFlag]
    
}

extension FlagCollection: AnyFlagCollection {
    
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
    
}

internal extension Sequence {
    
    func featureFlags () -> [AnyFlag] {
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
