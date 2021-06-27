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

extension Flag {
    
    /// Defines how the key which identify a flag should be evaluated.
    /// - `default`: the default behaviour of the provider.
    /// - `kebabCase`: apply kebab-case transformation to key (ie. `superDuperProperty` becomes `super-duper-property`)
    /// - `snakeCase`: apply snake-case transformation to key (ie. `superDuperProperty` becomes `super_duper_property`).
    /// - `custom`: manually specify the key to use (combined with parent group).
    /// - `path`: manually specify a fully qualified url style path for this flag (combines with parent group).
    public enum KeyEncodingStrategy {
        case `default`
        case snakeCase
        case kebabCase
        case custom(String)
        case path(String)
    }
    
    
}
