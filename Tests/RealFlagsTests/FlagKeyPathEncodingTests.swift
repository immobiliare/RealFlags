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

import XCTest
@testable import RealFlags

final class FlagKeyPathEncodingTests: XCTestCase {
    
    fileprivate static let customIcon: UIImage = UIImage()
    
    private lazy var kebabLoader: FlagsLoader<TestFlags> = {
        let config = KeyConfiguration(prefix: "prefix", pathSeparator: "/", keyTransform: .kebabCase)
        return FlagsLoader(TestFlags.self, keyConfiguration: config)
    }()
    
    private lazy var snakeLoader: FlagsLoader<TestFlags> = {
        let config = KeyConfiguration(pathSeparator: ".", keyTransform: .snakeCase)
        return FlagsLoader(TestFlags.self, keyConfiguration: config)
    }()
    
    func testKeyPathsKebab() {
        XCTAssert(kebabLoader.oneFlagGroup.$secondLevelFlag.keyPath.fullPath == "prefix/second-level-flag")
        XCTAssert(kebabLoader.oneFlagGroup.twoFlagGroup.$thirdLevelFlag2.keyPath.fullPath == "prefix/two/third-level-flag2")
        XCTAssert(kebabLoader.oneFlagGroup.twoFlagGroup.flagGroupThree.$standardPropertyName.keyPath.fullPath == "prefix/two/flag_group_three/standard-property-name")
        XCTAssert(kebabLoader.oneFlagGroup.twoFlagGroup.flagGroupThree.$full.keyPath.fullPath == "prefix/two/flag_group_three/fullKey")
        XCTAssert(kebabLoader.$topLevelFlag.keyPath.fullPath == "prefix/top-level-flag")
    }
    
    func testKeyPathsSnakeLoader() {
        XCTAssert(snakeLoader.oneFlagGroup.twoFlagGroup.flagGroupThree.$full.keyPath.fullPath == "two.flag_group_three.fullKey")
        XCTAssert(snakeLoader.oneFlagGroup.$secondLevelFlag.keyPath.fullPath == "second_level_flag")
        XCTAssert(snakeLoader.oneFlagGroup.twoFlagGroup.$thirdLevelFlag.keyPath.fullPath == "two.third_level_flag")
        XCTAssert(snakeLoader.$topLevelFlag.keyPath.fullPath == "top_level_flag")
    }
    
}


// MARK: - Fixtures

private struct TestFlags: FlagCollectionProtocol {

    @FlagCollection(keyConfiguration: .skip, description: "Test 1")
    var oneFlagGroup: OneFlags

    @Flag(default: false, description: "Top level test flag")
    var topLevelFlag: Bool

}

private struct OneFlags: FlagCollectionProtocol {

    @FlagCollection(keyConfiguration: .custom("two"), description: "Test Two")
    var twoFlagGroup: TwoFlags

    @Flag(default: false, description: "Second level test flag")
    var secondLevelFlag: Bool
}

private struct TwoFlags: FlagCollectionProtocol {

    @FlagCollection(keyConfiguration: .snakeCase, description: "Skipping test 3")
    var flagGroupThree: ThreeFlags

    @Flag(default: false, description: "Third level test flag")
    var thirdLevelFlag: Bool

    @Flag(default: false, description: "Second Third level test flag")
    var thirdLevelFlag2: Bool

}

private struct ThreeFlags: FlagCollectionProtocol {

    @Flag(key: "fullKey", default: false, description: "Test flag with custom key path")
    var full: Bool

    @Flag(default: true, description: "Standard Flag")
    var standardPropertyName: Bool

}

