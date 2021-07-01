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
import FirebaseRemoteConfig

// MARK: - FirebaseRemoteConfigProviderDelegate

public protocol FirebaseRemoteConfigProviderDelegate: AnyObject {
    
    /// Called when initialization did ends.
    ///
    /// - Parameters:
    ///   - remote: remote configuration provider.
    ///   - didFetchData: status.
    ///   - error: error description if any.
    func firebaseProvider(_ remote: FirebaseRemoteConfigProvider, didFetchData: RemoteConfigFetchAndActivateStatus, error: Error?)
    
}

// MARK: - FirebaseRemoteConfigProvider

public class FirebaseRemoteConfigProvider: FlagProvider {
    
    // MARK: - Public Properties
    
    /// Name of the remote configuration.
    public var name: String = "FirebaseRemoteConfigProvider"
    
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
            
        default:
            return nil
            
        }
    }
    
    public func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value : FlagProtocol {
        false
    }
    
    
}

// MARK: - Unwrap Type

protocol OptionalProtocol {
  // the metatype value for the wrapped type.
  static var wrappedType: Any.Type { get }
}

extension Optional : OptionalProtocol {
  static var wrappedType: Any.Type { return Wrapped.self }
}

internal func wrappedTypeFromOptionalType(_ type: Any.Type) -> Any.Type? {
  return (type as? OptionalProtocol.Type)?.wrappedType
}
