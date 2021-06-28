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

/// Defines how the key which identify a flag should be evaluated.
/// - `automatic`: the default behaviour of the provider, key is automatic evaluated from any parent structure and value given
/// - `kebabCase`: apply kebab-case transformation to key (ie. `superDuperProperty` becomes `super-duper-property`)
/// - `snakeCase`: apply snake-case transformation to key (ie. `superDuperProperty` becomes `super_duper_property`).
/// - `custom`: manually specify the key to use (combined with parent group).
/// - `path`: manually specify a fully qualified url style path for this flag (combines with parent group).
public enum FlagKey {
    case automatic
    case snakeCase
    case kebabCase
    case custom(String)
    case path(String)
}
