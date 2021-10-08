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

/// Is used as generic parent type for `AnyFlag` and `AnyFlagCollection` type.
public protocol AnyFlagOrCollection {
    
    /// Childs.
    func hierarchyFeatureFlags() -> [AnyFlagOrCollection]
    
    /// Metadata associated.
    var metadata: FlagMetadata { get }
    
}
