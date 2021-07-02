    import XCTest
    @testable import BentoFlags
    @testable import BentoFlagsFirebase
    
    final class BentoFlagsTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            
            let eStorage = LocalProvider(localURL: URL(fileURLWithPath: "/Users/daniele/Desktop/tet.plist"))
            //let eStorage = EphemeralProvider(name: "my provider")
            //let jsonProvider = JSONProvider()
            let firebaseRemote = FirebaseRemoteConfigProvider()
            let loader = FlagsLoader(MyCollection.self, providers: [eStorage])
            
            let r = loader.sottogruppo.user
            
            loader.sottogruppo.$user.setValue(User(name: "franco", age: 33, isMale: true), providers: nil)
            //            loader.sottogruppo.$user.setValue(nil, providers: nil)
            
            print(r)
        }
    }
    
    struct MyFlags: FlagCollectionProtocol {
        
        @FeatureFlag(default: false, description: "This is a test flag")
        var testFlag: Bool
        
        @FeatureFlag(default: false, description: "This is a test flag")
        var testFlag2: Bool
        
        @FeatureFlag(default: User(name: "gino", age: 23, isMale: true), description: "This is a test flag")
        var user: User
        
    }
    
    struct MyCollection: FlagCollectionProtocol {
        
        @FeatureFlagCollection(description: "The collection")
        var sottogruppo: MyFlags
        
    }
    
    struct User: FlagProtocol, Codable {
        public var name: String
        public var age: Int
        public var isMale: Bool
    }
