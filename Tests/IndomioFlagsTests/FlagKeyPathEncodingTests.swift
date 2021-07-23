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

import XCTest
@testable import IndomioFlags

final class FlagKeyPathEncodingTests: XCTestCase {
    
    fileprivate static let customIcon: UIImage = UIImage()
    
    private lazy var kebabLoader: FlagsLoader<TestFlags> = {
        let config = KeyConfiguration(prefix: "prefix", pathSeparator: "/", keyTransform: .kebabCase)
        return FlagsLoader(TestFlags.self, keyConfiguration: config)
    }()
    
    func testRootFlagsMetadata() {
        print(kebabLoader.oneFlagGroup.$secondLevelFlag.keyPath)
    }
    
}


// MARK: - Fixtures

private struct TestFlags: FlagCollectionProtocol {

    @FlagCollection(keyConfiguration: .skip, description: "Test 1")
    var oneFlagGroup: OneFlags

   // @Flag(default: false, description: "Top level test flag")
    //var topLevelFlag: Bool

}

private struct OneFlags: FlagCollectionProtocol {

    //@FlagCollection(keyConfiguration: .custom("two"), description: "Test Two")
    //var twoFlagGroup: TwoFlags

    @Flag(default: false, description: "Second level test flag")
    var secondLevelFlag: Bool
}
/*
private struct TwoFlags: FlagCollectionProtocol {

    @FlagCollection(keyConfiguration: .skip, description: "Skipping test 3")
    var flagGroupThree: ThreeFlags

    @Flag(default: false, description: "Third level test flag")
    var thirdLevelFlag: Bool

    @Flag(default: false, description: "Second Third level test flag")
    var thirdLevelFlag2: Bool

}

private struct ThreeFlags: FlagCollectionProtocol {

    @Flag(default: false, description: "Test flag with custom key")
    var custom: Bool

    @Flag(default: false, description: "Test flag with custom key path")
    var full: Bool

    @Flag(default: true, description: "Standard Flag")
    var standard: Bool

}
*/
