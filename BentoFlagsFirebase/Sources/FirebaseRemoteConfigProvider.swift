//
//  BentoFlags
//  Easily manage feature flags in Swift.
//
//  Created by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation
import BentoFlags

public class FirebaseRemoteConfigProvider: FlagProvider {
    public var name: String = "Firebase"
    
    public func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value : FlagProtocol {
        nil
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value : FlagProtocol {
        false
    }
    
}
