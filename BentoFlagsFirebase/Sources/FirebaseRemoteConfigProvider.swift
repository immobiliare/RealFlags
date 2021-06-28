//
//  File.swift
//  
//
//  Created by Daniele on 28/06/21.
//

import Foundation
import BentoFlags

public class FirebaseRemoteConfigProvider: FlagProvider {
    public var name: String = "Firebase"
    
    public func valueForFlag<Value>(_ key: String) -> Value? where Value : FlagProtocol {
        nil
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: String) throws where Value : FlagProtocol {
        
    }
    
    
}
