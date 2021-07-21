//
//  IndomioFlags
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
import XCTest

public func AssertNoThrow (file: StaticString = #filePath, line: UInt = #line, _ expression: () throws -> Void) {
    XCTAssertNoThrow(try expression(), file: file, line: line)
}

public func AssertThrows<E> (error: E, file: StaticString = #filePath, line: UInt = #line, _ expression: () throws -> Void) where E: Equatable {
    var result: E?
    XCTAssertThrowsError(try expression(), file: file, line: line) { thrownError in
        result = thrownError as? E
    }
    XCTAssertEqual(result, error)
}

@discardableResult
public func AssertThrows (file: StaticString = #filePath, line: UInt = #line, _ expression: () throws -> Void) -> Swift.Error? {
    var result: Swift.Error?
    XCTAssertThrowsError(try expression(), file: file, line: line) { thrownError in
        result = thrownError
    }
    return result
}
