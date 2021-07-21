    import XCTest
    @testable import IndomioFlags
    
    final class FlagTests: XCTestCase {
        
        func testProperties() {
            let loader = FlagsLoader(FlagsCollection.self)
            
            print(loader.testBoolean.description)
            XCTAssert(loader.testBoolean.description == "Short Desc", "Failed to set short description")
            
        }
        
    }
    

    fileprivate struct FlagsCollection: FlagCollectionProtocol {
        
        @Flag(name: "myBoolProperty", key: "custom_bool_key", default: true, description: "Short Desc")
        var testBoolean: Bool
        
    }
