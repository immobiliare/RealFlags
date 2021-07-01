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

public class JSONData {
    
    // MARK: - Private Properties
    
    /// Dictionary contents
    private var dictionary: NSDictionary
    
    // MARK: - Initialization
    
    /// Initialize a new JSON with data.
    ///
    /// - Parameter dict: dictionary
    public init(_ dict: NSDictionary?) {
        self.dictionary = dict ?? [:]
    }
    
    /// Initialize with a dictionary.
    ///
    /// - Parameter dict: dictionary.
    public init(_ dict: [String: Any]) {
        self.dictionary = dict as NSDictionary
    }
    
    required public init?(encoded value: EncodedFlagValue) {
        switch value {
        case .json(let dict):
            self.dictionary = dict
        default:
            return nil
        }
    }
    
    // MARK: - Public Functions
    
    /// Get the value for a given keypath.
    ///
    /// - Parameter keyPath: keypath.
    /// - Returns: V?
    public func valueForKey<V>(_ keyPath: String) -> V?  {
        return dictionary.value(forKeyPath: keyPath) as? V
    }
    
}

// MARK: JSONData (FlagProtocol)

extension JSONData: FlagProtocol {
    public typealias EncodedValue = NSDictionary

    public func encoded() -> EncodedFlagValue {
        .json(self.dictionary)
    }
    
}
