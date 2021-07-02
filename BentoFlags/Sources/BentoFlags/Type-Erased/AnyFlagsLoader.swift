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

public protocol AnyFlagsLoader {
    
    /// Providers of the flag.
    var providers: [FlagProvider]? { get }
    
    /// Type of collection group loaded by loader instance.
    var collectionType: String { get }
    
    /// Collection of flags
    var collection: AnyFlagCollection? { get }

}

extension FlagsLoader: AnyFlagsLoader {

    public var collectionType: String {
        String(describing: type(of: loadedCollection))
    }
    
    public var collection: AnyFlagCollection? {
        print(loadedCollection)
        let x = loadedCollection as? AnyFlagCollection
        return x
    }
    
}
