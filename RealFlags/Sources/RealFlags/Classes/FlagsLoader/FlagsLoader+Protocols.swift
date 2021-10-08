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

// MARK: - FlagsLoaderProtocol

/// Identify the basic properties of a `FlagLoader` instance.
public protocol FlagsLoaderProtocol: AnyObject {
    
    /// Ordered list of providers for data.
    var providers: [FlagsProvider]? { get }
    
    /// Defines how the automatic keypath for property is produced.
    var keyConfiguration: KeyConfiguration { get }
    
}

// MARK: - FeatureFlagConfigurableProtocol

public typealias KeyPathAndConfig = (path: String, keyConfiguration: KeyConfiguration?)

/// This is just an internal protocol used to initialize the contents of a collection or a flag
/// with a specific `FlagLoader` instance.
/// You should never use it.
public protocol FeatureFlagConfigurableProtocol {
    
    /// Configure class with specific loader.
    ///
    /// - Parameters:
    ///   - loader: loader instance.
    ///   - propertyName: property name.
    ///   - keyPath: keyPath components.
    func configureWithLoader(_ loader: FlagsLoaderProtocol, propertyName: String, keyPath: [KeyPathAndConfig])
    
}
