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

public struct FlagKeyPath: Equatable, Hashable {
    
    // MARK: - Public Properties
    
    /// Components of the key to retrive.
    public let pathComponents: [String]
    
    /// Separator set.
    public let pathSeparator: String
    
    var fullPath: String {
        pathComponents.joined(separator: pathSeparator)
    }
    
    var key: String {
        pathComponents.last ?? ""
    }
    
    // MARK: - Initialization
    
    internal init(components: [String], separator: String) {
        self.pathComponents = components
        self.pathSeparator = separator
    }

}
