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
    
    /// Initialize with json string. Return `nil` if invalid json.
    ///
    /// - Parameter jsonString: json string
    public init?(jsonString: String) {
        guard let dict = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!,
                                                           options: .allowFragments) as? NSDictionary else {
            return nil
        }
        self.dictionary = dict
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
