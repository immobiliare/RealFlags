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

public protocol AnyFlagsLoader {
    
    /// Providers of the flag.
    var providers: [FlagsProvider]? { get }
    
    /// Type of collection group loaded by loader instance.
    var collectionType: String { get }
    
    /// List of feature flags of the loader.
    var featureFlags: [AnyFlag] { get }
    
    /// Hierarchical list of flags of the loader.
    var hierarcyFeatureFlags: [AnyFlagOrCollection] { get }
    
    /// Description of the key configuration.
    var keyConfiguration: KeyConfiguration { get }
    
    /// Metadata associated with loader.
    var metadata: FlagMetadata? { get }
    
}

extension FlagsLoader: AnyFlagsLoader {

    public var collectionType: String {
        String(describing: type(of: loadedCollection))
    }
    
}
