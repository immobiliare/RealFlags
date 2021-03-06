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

/// A type that represents the wrapped value of a `Flag`
///
/// This type exists solely so we can provide hints for boxing/unboxing or encoding/decoding
/// into various `FlagsProvider`s.
public protocol FlagProtocol {

    /// Defines the type of encoded type used to represent the flag value.
    /// For `Codable` support, a default boxed type of `Data` is assumed if you
    /// do not specify one directly.
    associatedtype EncodedValue = Data

    /// You must be able to decode your conforming object in order to unbox it.
    /// Return `nil` if you fails to decode.
    ///
    /// - Parameter encoded: encoded value.
    init?(encoded value: EncodedFlagValue)
    
    /// You must be able to encode a type to the relative `EncodedFlagValue` instance.
    func encoded() -> EncodedFlagValue
    
}
