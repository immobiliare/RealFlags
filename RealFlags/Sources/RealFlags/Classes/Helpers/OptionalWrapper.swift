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

// MARK: - Unwrap Type

protocol OptionalProtocol {
    // the metatype value for the wrapped type.
    static var wrappedType: Any.Type { get }
}

extension Optional: OptionalProtocol {
    static var wrappedType: Any.Type { return Wrapped.self }
}

public func wrappedTypeFromOptionalType(_ type: Any.Type) -> Any.Type? {
    return (type as? OptionalProtocol.Type)?.wrappedType
}
