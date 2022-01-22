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

import UIKit

/// This represent the metadata information associated with a flag.
/// Typically these values are read from the UI interface or can be used as documented reference inside the code.
public struct FlagMetadata {
    
    /// Name of the flag/group.
    public var name: String?
    
    /// Custom icon assigned in Flags Browser.
    /// If not value is set the default data type icon is used instead.
    public var uiIcon: UIImage?
    
    /// When set to `true` the flag can't be altered by using the Flags Browser.
    /// By default is set to `false`.
    /// NOTE: you can still alter it via code.
    public var isLocked = false
    
    /// A short description of the flag. You should really provider a context in order to avoid confusion, this
    /// this the reason this is the only property which is not set to optional.
    public var description: String
    
    /// If true this key should be not visibile by any tool which read values.
    /// By default is set to `false`.
    public var isInternal = false
    
    /// Where applicable the index defines the order of the item into a UI list view.
    public var order: Int = 0
    
    // MARK: - Initialization
    
    public init(name: String? = nil, description: String, order: Int = 0,
                isInternal: Bool = false,
                uiIcon: UIImage? = nil,
                isLocked: Bool = false) {
        self.name = name
        self.description = description
        self.order = order
        self.isInternal = isInternal
        self.uiIcon = uiIcon
        self.isLocked = isLocked
    }
    
}

// MARK: - String Literal Support

/// It's used to initialize a new flag metadata directly with only the description string instead of
/// creating the `FlagMetadata` object.
extension FlagMetadata: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(description: value, isInternal: false)
    }
    
}
