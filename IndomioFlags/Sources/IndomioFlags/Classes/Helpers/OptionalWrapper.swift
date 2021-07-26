//
//  File.swift
//  
//
//  Created by Daniele on 01/07/21.
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
