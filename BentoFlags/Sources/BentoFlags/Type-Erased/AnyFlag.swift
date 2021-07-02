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

protocol AnyFlag {
    
    /// Return the key for flag.
    var keyPath: FlagKeyPath { get }
    
    /// Return the value of the flag.
    func getValueForFlag() -> Any?
    
    /// Save a value to a provider (if supported).
    ///
    /// - Parameter provider: provider to use.
    func setValueToProvider(_ provider: FlagProvider) throws
    
}

extension FeatureFlag: AnyFlag {
    
    func getValueForFlag() -> Any? {
        flagValue()
    }
    
    func setValueToProvider(_ provider: FlagProvider) throws {
        try provider.setValue(self.wrappedValue, forFlag: keyPath)
    }
    
}
