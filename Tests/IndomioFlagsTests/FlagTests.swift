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

final class FlagTests: XCTestCase {
    
    fileprivate static let customIcon: UIImage = UIImage()
    
    private lazy var loader: FlagsLoader<FlagsCollection> = {
        FlagsLoader(FlagsCollection.self)
    }()
    
    func testRootFlagsMetadata() {
        // Metadata assigned
        XCTAssert(loader.$flagBool.metadata.description == "Some Boolean")
        XCTAssert(loader.$flagBool.metadata.name == "myBoolProperty")
        
        // Default values
        XCTAssert(loader.$flagBool.metadata.isInternal == false)
        XCTAssert(loader.$flagBool.metadata.isLocked == false)
        XCTAssert(loader.$flagBool.metadata.uiIcon == nil)
        
        // Custom Metadata object
        XCTAssert(loader.$flagString.metadata.uiIcon === FlagTests.customIcon)
        XCTAssert(loader.$flagString.metadata.isInternal == true)
        XCTAssert(loader.$flagString.metadata.isLocked == true)
        XCTAssert(loader.$flagString.metadata.description == "Some text")
    }
    
    func testNestedFlagsMetadata() {
        XCTAssert(loader.nested.$nestedIntFlagFixKey.metadata.isInternal == true)
        XCTAssert(loader.nested.$nestedIntFlagFixKey.metadata.isLocked == true)
        XCTAssert(loader.nested.$nestedIntFlagFixKey.metadata.uiIcon === FlagTests.customIcon)
        XCTAssert(loader.nested.$nestedIntFlagFixKey.defaultValue == 53)
    }
    
    func testFlagKeyPathAndNames() {
        // Root level's flags
        XCTAssert(loader.$flagBool.keyPath.fullPath == "custom_bool_key")
        XCTAssert(loader.$flagBool.defaultValue == true)
        
        XCTAssert(loader.$flagString.keyPath.fullPath == "custom_string")
        
        // Nested collection's flags
        XCTAssert(loader.nested.$nestedIntFlag.keyPath.fullPath == "nested/nested_int_flag")
        XCTAssert(loader.nested.$nestedIntFlagFixKey.keyPath.fullPath == "fixed_property_key")
        XCTAssert(loader.nested.$nestedIntFlagFixKey.name == "nestedInt_customName")
        
        XCTAssert(loader.nested.$nestedArray.defaultValue == [2,3,5])
        XCTAssert(loader.nested.$nestedArray.metadata.description == "Nested array")
    }
    
    func testChildsIntrospection() {
        print(loader.featureFlags.count)
        
        // It generated a flat list of all feature flags into the root and any child (removing references to collection)
        XCTAssert(loader.featureFlags.count == 5)
        // It just return the list of current level flags including nested collections references
        XCTAssert(loader.hierarcyFeatureFlags.count == 3)
    }
    
}

// MARK: - Example Structures

fileprivate struct FlagsCollection: FlagCollectionProtocol {
    
    @Flag(name: "myBoolProperty",
          key: "custom_bool_key",
          default: true,
          description: "Some Boolean")
    var flagBool: Bool
    
    @Flag(key: "custom_string",
          default: "fallback_string",
          description: FlagMetadata(description: "Some text", isInternal: true, uiIcon: FlagTests.customIcon, isLocked: true))
    var flagString: String
    
    @FlagCollection(description: "A nested collection")
    var nested: NestedCollection
    
}

fileprivate struct NestedCollection: FlagCollectionProtocol {
    
    @Flag(default: 5,
          description: FlagMetadata(description: "nested flag desc", isInternal: true, uiIcon: FlagTests.customIcon, isLocked: true))
    var nestedIntFlag: Int
    
    @Flag(name: "nestedInt_customName",
          key: "fixed_property_key",
          default: 53,
          description: FlagMetadata(description: "nested flag desc", isInternal: true, uiIcon: FlagTests.customIcon, isLocked: true))
    var nestedIntFlagFixKey: Int
    
    @Flag(default: [2,3,5], description: "Nested array")
    var nestedArray: [Int]
    
}
