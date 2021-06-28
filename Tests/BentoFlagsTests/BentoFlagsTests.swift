    import XCTest
    @testable import BentoFlags
    @testable import BentoFlagsFirebase

    final class BentoFlagsTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            
            let eStorage = EphemeralProvider(name: "my provider")
            let firebaseRemote = FirebaseRemoteConfigProvider()
            let loader = FlagsLoader(MyCollection.self, providers: [firebaseRemote])
            
            let r = loader.sottogruppo.testFlag
            print(r)
        }
    }

    struct MyFlags: FlagCollectionProtocol {
        
        @Flag(default: false, description: "This is a test flag")
        var testFlag: Bool

        @Flag(default: false, description: "This is a test flag")
        var testFlag2: Bool

        /*@Flag(defaultValue: false, description: "This is a test flag")
        var testFlag3: Bool

        @Flag(defaultValue: false, description: "This is a test flag")
        var testFlag4: Bool*/
        
    }
    
    struct MyCollection: FlagCollectionProtocol {
        
        @FlagCollection(description: "MERDA")
        var sottogruppo: MyFlags
        
    }
