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

}

extension FlagsLoader: AnyFlagsLoader { }
