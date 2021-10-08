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

import XCTest
@testable import RealFlags

/// Test how the value are encoded.
final class FlagValueEncodedTests: XCTestCase {
    
    // MARK: - Boolean Flag Values
    
    func testBooleanTrueFlagValue () {
        let input = true
        let expected = EncodedFlagValue.bool(true)
        XCTAssertEqual(input.encoded(), expected)
    }
    
    func testBooleanFalseFlagValue () {
        let input = false
        let expected = EncodedFlagValue.bool(false)
        XCTAssertEqual(input.encoded(), expected)
    }

    // MARK: - String Flag Values

    func testStringFlagValue () {
        let input = "Some Test String"
        let expected = EncodedFlagValue.string("Some Test String")
        XCTAssertEqual(input.encoded(), expected)
    }

    func testURLStringFlagValue () {
        let input = URL(string: "https://www.apple.com/")!
        let expected = EncodedFlagValue.string("https://www.apple.com/")
        XCTAssertEqual(input.encoded(), expected)
    }
    
    // MARK: - Integer Flag Values

    func testIntFlagValue () {
        let input: Int = 345
        let expected = EncodedFlagValue.integer(345)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testInt8FlagValue () {
        let input: Int8 = 22
        let expected = EncodedFlagValue.integer(22)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testInt16FlagValue () {
        let input: Int16 = 33
        let expected = EncodedFlagValue.integer(33)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testInt32FlagValue () {
        let input: Int32 = 456
        let expected = EncodedFlagValue.integer(456)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testInt64FlagValue () {
        let input: Int64 = 111
        let expected = EncodedFlagValue.integer(111)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testUIntFlagValue () {
        let input: UInt = 343
        let expected = EncodedFlagValue.integer(343)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testUInt8FlagValue () {
        let input: UInt8 = 2
        let expected = EncodedFlagValue.integer(2)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testUInt16FlagValue () {
        let input: UInt16 = 222
        let expected = EncodedFlagValue.integer(222)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testUInt32FlagValue () {
        let input: UInt32 = 123
        let expected = EncodedFlagValue.integer(123)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testUInt64FlagValue () {
        let input: UInt64 = 123
        let expected = EncodedFlagValue.integer(123)
        XCTAssertEqual(input.encoded(), expected)
    }

    // MARK: - Data Flag Values

    func testDataFlagValue () {
        let input = Data("Test string".utf8)
        let expected = EncodedFlagValue.data(input)

        XCTAssertEqual(input.encoded(), expected)
    }
    
    // MARK: - Date Flag Values

    func testDateFlagValue () {
        let input = Date()
        let formatter = ISO8601DateFormatter()
        let expected = EncodedFlagValue.string(formatter.string(from: input))

        XCTAssertEqual(input.encoded(), expected)
    }

    // MARK: - Floating Point Flag Values

    func testFloatFlagValue () {
        let input: Float = 245.542
        let expected = EncodedFlagValue.float(245.542)

        XCTAssertEqual(input.encoded(), expected)
    }

    func testDoubleFlagValue () {
        let input: Double = 245.542
        let expected = EncodedFlagValue.double(245.542)

        XCTAssertEqual(input.encoded(), expected)
    }

    // MARK: - Wrapping Types

    func testRawRepresentableFlagValue () {
        let input = TestStruct(rawValue: 333)
        let expected = EncodedFlagValue.integer(333)
        XCTAssertEqual(input.encoded(), expected)

        struct TestStruct: RawRepresentable, FlagProtocol, Equatable {
            let rawValue: Int
        }
    }

    func testOptionalSomeFlagValue () {
        let input: Int? = 1
        let expected = EncodedFlagValue.integer(1)
        XCTAssertEqual(input.encoded(), expected)
    }

    func testOptionalNoFlagValue () {
        let input: Int? = nil
        let expected = EncodedFlagValue.none
        XCTAssertEqual(input.encoded(), expected)
    }

    // MARK: - Collection Flag Values

    func testArrayFlagValue () {
        let input = [ 123, 111, 222 ]
        let expected = EncodedFlagValue.array([ .integer(123), .integer(111), .integer(222) ])
        XCTAssertEqual(input.encoded(), expected)
    }

    func testDictionaryFlagValue () {
        let input = [ "one": 1, "two": 2, "three": 3 ]
        let expected = EncodedFlagValue.dictionary([ "one": .integer(1), "two": .integer(2), "three": .integer(3) ])
        XCTAssertEqual(input.encoded(), expected)
    }

    // MARK: - Codable Types

    func testCodableFlagValue () {
        AssertNoThrow {
            let input = TestStruct()
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let data = try encoder.encode(input)
            let expected = EncodedFlagValue.data(data)

            XCTAssertEqual(input.encoded(), expected)
        }

        struct TestStruct: Codable, FlagProtocol, Equatable {
            let property1: Int
            let property2: String
            let property3: Double

            init () {
                self.property1 = 123
                self.property2 = "456"
                self.property3 = 789.0
            }
        }
    }
}
