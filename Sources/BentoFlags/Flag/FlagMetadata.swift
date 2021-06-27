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

/// This represent the metadata information associated with a flag.
/// Typically these values are read from the UI interface or can be used as documented reference inside the code.
public struct FlagMetadata {
    
    /// Name of the flag/group.
    public var name: String?
    
    /// A short description of the flag. You should really provider a context in order to avoid confusion, this
    /// this the reason this is the only property which is not set to optional.
    public var description: String
    
    /// If true this key should be not visibile by any tool which read values.
    /// By default is set to `false`.
    public var isInternal = false
    
    // MARK: - Initialization
    
    init(name: String? = nil, description: String, isInternal: Bool = false) {
        self.name = name
        self.description = description
        self.isInternal = isInternal
    }
    
}

// MARK: - String Literal Support

/// It's used to initialize a new flag metadata directly with only the description string instead of
/// creating the `FlagMetadata` object.
extension FlagMetadata: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(name: nil, description: value, isInternal: false)
    }
    
}

