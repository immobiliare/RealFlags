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

class LocalProviderTests: XCTestCase {
    
    fileprivate var loader: FlagsLoader<LPFlagsCollection>!
    
    fileprivate lazy var localProviderFileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("LocalProviderTest.xml")
        return fileURL
    }()
    
    fileprivate lazy var localProvider = LocalProvider(localURL: localProviderFileURL)
    
    override func setUp() {
        super.setUp()
        loader = FlagsLoader<LPFlagsCollection>(LPFlagsCollection.self, providers: [localProvider])
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testResetKeyPathValue() throws {
        for _ in 0..<2 {
            // Reset any stored data on local provider (only for second pass)
            try localProvider.resetAllData()
            // Test if file was removed
            XCTAssertFalse(FileManager.default.fileExists(atPath: localProviderFileURL.path))

            // Returned value should be the default one set
            print(loader.nested.flagInt)
            XCTAssertEqual(loader.nested.flagInt, 2)
            
            // Chaning the default value should reflect on query
            loader.nested.$flagInt.setDefault(100)
            XCTAssertEqual(loader.nested.flagInt, 100)
            
            // Changing the value should be reflected on query
            loader.nested.$flagInt.setValue(200)
            XCTAssertEqual(loader.nested.flagInt, 200)
            // Check if file is written correctly
            XCTAssertTrue(FileManager.default.fileExists(atPath: localProviderFileURL.path))
            
            let dataString = try String(contentsOf: localProviderFileURL)
            let hasValidValue = dataString.contains("<key>flag_int</key>\n\t\t<integer>200</integer>")
            XCTAssertTrue(hasValidValue)
            
            // Change root key
            loader.$flagBool.setValue(false)
            
            // Reset should return to the last default one set
            try? loader.nested.$flagInt.resetValue()
            XCTAssertEqual(loader.nested.flagInt, 100)
            
            // Validate other key after reset
            XCTAssertFalse(loader.flagBool)
            let dataStringAfterReset = try String(contentsOf: localProviderFileURL)
            let hasValidValueAfterReset = dataStringAfterReset.contains("<key>flag_bool</key>\n\t<false/>")
            XCTAssertTrue(hasValidValueAfterReset)
            
            // Restore initial state
            loader.nested.$flagInt.setDefault(2)
        }
    }
}


fileprivate struct LPFlagsCollection: FlagCollectionProtocol {
    
    @Flag(default: true, description: "")
    var flagBool: Bool
    
    @FlagCollection(description: "")
    var nested: LPNestedFlagsCollection
    
}

fileprivate struct LPNestedFlagsCollection: FlagCollectionProtocol {
    
    @Flag(default: 2, description: "")
    var flagInt: Int
    
    @Flag(default: "fallback_string", description: "")
    var flagString: String
    
}
