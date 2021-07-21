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
import IndomioFlags
import FirebaseRemoteConfig
import Firebase

/// FirebaseRemoteProvider is an layer above the FirebaseRemoteConfig which support
/// retriving data from Firebase's Remote Config.
public class FirebaseRemoteProvider: FlagsProvider {
    
    // MARK: - Public Properties
    
    /// Name of the remote configuration.
    public var name: String = "Firebase Remote"
    
    /// Does not support writing values.
    public var isWritable = false
    
    /// Short description.
    public var shortDescription: String? {
        FirebaseApp.app()?.name
    }
    
    /// Delegate.
    public weak var delegate: FirebaseRemoteConfigProviderDelegate?
    
    // MARK: - Private Properties
    
    /// Remote configuration.
    private var remoteConfig: RemoteConfig
    
    // MARK: - Initialization
    
    /// Initialzie a new firebase remote configuration provider with specified settings.
    /// If no settings are sent the default `init()` for `RemoteConfigSettings` is used.
    ///
    /// NOTE:
    /// Remember to initialize your Firebase SDK before using this service.
    /// You should have already called `FirebaseApp.configure()` method before initializing this object.
    ///
    /// - Parameter settings: settings for remote configuration
    public init(settings: RemoteConfigSettings = .init()) {
        self.remoteConfig = RemoteConfig.remoteConfig()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetchAndActivate(completionHandler: { [weak self] (status, activationError) in
            guard let self = self else { return }
            
            self.delegate?.firebaseProvider(self, didFetchData: status, error: activationError)
        })
    }

    public func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value : FlagProtocol {
        let firebaseData = remoteConfig.configValue(forKey: key.fullPath)
                
        let resultType = wrappedTypeFromOptionalType(Value.self)
        switch resultType {
        case is String.Type:
            return firebaseData.stringValue as? Value
            
        case is Bool.Type:
            return firebaseData.boolValue as? Value
            
        case is Data.Type:
            return firebaseData.dataValue as? Value
            
        case is NSNumber.Type:
            return firebaseData.numberValue as? Value
            
        case is Float.Type:
            return firebaseData.numberValue.floatValue as? Value
            
        case is Double.Type:
            return firebaseData.numberValue.doubleValue as? Value

        case is Int8.Type:
            return firebaseData.numberValue.int8Value as? Value
            
        case is Int16.Type:
            return firebaseData.numberValue.int16Value as? Value
            
        case is Int64.Type:
            return firebaseData.numberValue.int64Value as? Value
            
        case is UInt.Type:
            return firebaseData.numberValue.uintValue as? Value
            
        case is UInt8.Type:
            return firebaseData.numberValue.uint8Value as? Value
            
        case is UInt16.Type:
            return firebaseData.numberValue.uint16Value as? Value
            
        case is UInt32.Type:
            return firebaseData.numberValue.uint32Value as? Value
            
        case is UInt64.Type:
            return firebaseData.numberValue.uint64Value as? Value
            
        case is JSONData.Type:
            return JSONData(firebaseData.jsonValue as? NSDictionary) as? Value
            
        case is URL.Type:
            return URL(string: firebaseData.stringValue ?? "") as? Value
            
        case is Date.Type:
            return ISO8601DateFormatter().date(from: firebaseData.stringValue ?? "") as? Value
            
        default:
            return firebaseData.jsonValue as? Value

        }
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value : FlagProtocol {
        // Set is not supported
        false
    }
    
}
