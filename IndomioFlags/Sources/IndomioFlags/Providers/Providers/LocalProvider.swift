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

/// LocalProvider is a local source for feature flags. You can use this object for persistent local data
/// or ephemeral storage.
/// Values are stored as `Data` and all primitives and `Codable` conformant objects are supported.
public class LocalProvider: FlagsProvider, Identifiable {
    
    // MARK: - Public Properties
    
    /// Name of the ephemeral provider
    public let name: String
    
    /// Short description
    public var shortDescription: String?
    
    /// If you specify a local URL data will be stored automatically and resumed from that file.
    /// If you don't specify a local URL storage is ephemeral and no data will be stored.
    /// You can use this file to provide a writable data set.
    /// Use `Flag`'s `setValue()` function to overwrite existing keys.
    public let localURL: URL?
    
    /// Support writing values.
    public var isWritable = true
    
    // MARK: - Internal Properties
    
    /// Storage data.
    internal var storage: [String: Any]
    
    // MARK: - Initialization
    
    /// Initialize a new ephemeral storage which will be never saved locally.
    /// Data is maintained in memory until the lifecycle of the app did ends.
    ///
    /// - Parameters:
    ///   - name: name of the storage.
    ///   - values: initial dataset.
    public init(name: String? = nil, values: [String: Any] = [:]) {
        self.name = (name ?? "Ephemeral Provider")
        self.shortDescription = (UUID().uuidString).lowercased()
        self.storage = values
        self.localURL = nil
    }
    
    /// Initialize a new persistent storage.
    ///
    /// - Parameter localURL: local url of the file.
    public init(localURL: URL) {
        let fileExists = FileManager.default.fileExists(atPath: localURL.path)
        
        self.localURL = localURL
        self.storage = (!fileExists ? [:] : NSDictionary(contentsOfFile: localURL.path) as? [String: Any] ?? [:])
        self.shortDescription = "File Backed \((localURL.path as NSString).lastPathComponent)"
        self.name = "Local Provider"
    }
    
    // MARK: - FlagsProvider Conformance
    
    public func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value : FlagProtocol {
        guard let rawObject: Any = BentoDict.getValueInDictionary(storage, forKeyPath: key),
              let encodedFlag = EncodedFlagValue(object: rawObject, classType: Value.self) else {
            return nil
        }
        
        return Value(encoded: encodedFlag)
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value : FlagProtocol {
        let encodedValue = value?.encoded().nsObject()
        BentoDict.setValueForDictionary(&storage, value: encodedValue, keyPath: key)
        
        try? saveToDisk()
        return true
    }
    
    // MARK: - Persistent Management
    
    /// Force saving of the data locally (only if `localURL` has been set).
    /// NOTE: When you set a new value via `setValue()` function save is called automatically and you don't need to make it explicit.
    public func saveToDisk() throws {
        guard let localURL = self.localURL else {
            return
        }
        
        let data = NSDictionary(dictionary: storage)
        try data.write(to: localURL)
    }
    
}
