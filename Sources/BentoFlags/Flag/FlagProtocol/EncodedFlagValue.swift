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

// MARK: - EncodedFlagValue

/// Defines all the types you can encode/decode as flag value.
/// Custom type you conform to `FlagProtocol` must be able to be represented with one of the following types.
public enum EncodedFlagValue: Equatable {
    case array([EncodedFlagValue])
    case bool(Bool)
    case dictionary([String: EncodedFlagValue])
    case data(Data)
    case double(Double)
    case float(Float)
    case integer(Int)
    case none
    case string(String)
}
