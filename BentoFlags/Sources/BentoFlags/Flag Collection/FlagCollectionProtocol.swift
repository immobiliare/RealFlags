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

/// This is a protocol which allows you to group a list of `Flag` and `FlagCollection` objects
/// to better organize available feature flags; we must be able to initialize an empty collection.
public protocol FlagCollectionProtocol {
    init()
}
