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

public enum BentoDict {
    
    /// Set the value into a dictionary for a keypath.
    ///
    /// - Parameters:
    ///   - dict: source dictionary.
    ///   - value: value to set.
    ///   - keyPath: keypath to set.
    internal static func setValueForDictionary<V>(_ dict: inout [String: Any], value: V?, keyPath: FlagKeyPath) {
        switch keyPath.count {
        case 1:
            if let value = value {
                dict[keyPath.first!] = value
            } else {
                dict.removeValue(forKey: keyPath.first!)
            }
            
        case (2..<Int.max):
            let key = keyPath.first!
            var subDict = (dict[key] as? [String: Any]) ?? [:]
            setValueForDictionary(&subDict, value: value, keyPath: keyPath.dropFirst())
            dict[key] = subDict
            
        default:
            return
        }
    }
    
    /// Get the value of the object for a given keypath.
    ///
    /// - Parameters:
    ///   - dict: dictionary source of the data.
    ///   - keys: keypath.
    /// - Returns: typed value.
    internal static func getValueInDictionary<V>(_ dict: [String: Any], forKeyPath keys: FlagKeyPath) -> V? {
        switch keys.count {
        case 1:
            return dict[keys[0]!] as? V
        case (2..<Int.max):
            var running = dict
            
            let exceptLastOne = keys.pathComponents[0 ..< (keys.count - 1)]
            for key in exceptLastOne{
                if let r = running[key] as? [String: AnyObject]{
                    running = r
                }else{
                    return nil
                }
            }
            return running[keys.last!] as? V
        default:
            return nil
        }
    }
    
}
