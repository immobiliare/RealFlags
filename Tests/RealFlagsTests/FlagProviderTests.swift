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

public class LocalProviderA: LocalProvider { }
public class LocalProviderB: LocalProvider { }
public class UserDefaultsCustom: UserDefaults { }

final class FlagProviderTests: XCTestCase {
    
    private var localProviderOne = LocalProviderA(name: "#1")
    private var localProviderTwo = LocalProviderB(name: "#2")

    private var loader: FlagsLoader<TestFlags>!
    
    override func setUp() {
        super.setUp()
        
        self.loader = FlagsLoader(TestFlags.self, providers: [localProviderOne, localProviderTwo])
    }
    
    private func resetValuesOnProviders() {
        localProviderOne.storage = [
            "topLevel": 5,
            "topLevelFlag1": "A_VALUE",
            "excludedProp": "providerA_Value"
        ]
        localProviderTwo.storage = [
            "topLevel": 3,
            "topLevelFlag1": "B_VALUE",
            "excludedProp": "providerB_Value"
        ]
    }

    func testValuesHierarchy() {
        resetValuesOnProviders()
        
        XCTAssert(loader.$topLevelFlag.defaultValue == 0)

        // Test hierarchy of values
        XCTAssert(loader.topLevelFlag == 5)
        XCTAssert(loader.$topLevelFlag.getValueDescriptionForFlag().sourceProvider?.name == localProviderOne.name)
        localProviderOne.storage.removeValue(forKey: "topLevel")
        
        XCTAssert(loader.topLevelFlag == 3)
        XCTAssert(loader.$topLevelFlag.getValueDescriptionForFlag().sourceProvider?.name == localProviderTwo.name)
        localProviderTwo.storage.removeValue(forKey: "topLevel")
        
        XCTAssert(loader.topLevelFlag == 0)
        XCTAssert(loader.$topLevelFlag.getValueDescriptionForFlag().sourceProvider == nil)
    }
    
    func testSetValue() {
        resetValuesOnProviders()

        XCTAssert(loader.$topLevelFlag.setValue(-1, providers: [LocalProviderA.self]).count == 1)
        XCTAssert(loader.$topLevelFlag.flagValue(from: LocalProviderA.self, fallback: false).value == -1)
        
        loader.$topLevelFlag.setValue(nil, providers: [LocalProviderA.self, LocalProviderB.self])
        XCTAssert(loader.$topLevelFlag.flagValue(from: LocalProviderA.self, fallback: false).value == nil)
        XCTAssert(loader.$topLevelFlag.flagValue(from: LocalProviderB.self, fallback: false).value == nil)
        XCTAssert(loader.topLevelFlag == 0)
    }
    
    func testExcludedProviders() {
        resetValuesOnProviders()
        
        XCTAssert(loader.excludedProp == "providerB_Value")
        XCTAssert(loader.topLevelFlag1 == "A_VALUE")
    }
    
    func testValueDataType() {
        XCTAssert(loader.$topLevelFlag.dataType == Int.self)
        XCTAssert(loader.$topLevelFlag1.dataType == String.self)

        XCTAssert(loader.$topLevelFlag1.defaultValue == "x")
        XCTAssert(loader.$topLevelFlag1.defaultValue == "x")
    }
    
    func testUserDefaultsProvider() {
        resetValuesOnProviders()
        
        let userDefaults = UserDefaultsCustom(suiteName: "test_suite")!
        let testLoaderUD = FlagsLoader<TestFlags>(TestFlags.self, providers: [userDefaults, localProviderOne, localProviderTwo])

        testLoaderUD.$topLevelFlag.setValue(55, providers: [UserDefaultsCustom.self])
        XCTAssert(testLoaderUD.topLevelFlag == 55)

        testLoaderUD.$topLevelFlag.setValue(nil, providers: [UserDefaultsCustom.self])
        print(testLoaderUD.topLevelFlag)
        XCTAssert(testLoaderUD.topLevelFlag == 5)
    }
    
}

// MARK: - Fixtures

private struct TestFlags: FlagCollectionProtocol {

    @Flag(key:"topLevel", default: 0, description: "Top level test flag")
    var topLevelFlag: Int
    
    @Flag(key:"topLevelFlag1", default: "x", description: "")
    var topLevelFlag1: String
    
    @Flag(key: "excludedProp", default: "defaultValue", excludedProviders: [LocalProviderA.self], description: "")
    var excludedProp: String

}
