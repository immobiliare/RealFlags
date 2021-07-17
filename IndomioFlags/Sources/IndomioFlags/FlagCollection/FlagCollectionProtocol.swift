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

/// This is a protocol which allows you to group a list of `Flag` and `FlagCollection` objects
/// to better organize available feature flags; we must be able to initialize an empty collection.
public protocol FlagCollectionProtocol {
    init()
}
