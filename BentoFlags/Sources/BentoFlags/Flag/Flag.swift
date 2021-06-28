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

/// This a wrapper which represent a single Feature Flag.
/// The type that you wrap with `@Flag` must conform to `FlagProtocol`.
@propertyWrapper
public struct Flag<Value: FlagProtocol>: FeatureFlagConfigurableProtocol, Identifiable, CustomDebugStringConvertible {
    
    // MARK: - Public Properties
    
    /// Unique identifier of the feature flag.
    public var id = UUID()

    /// The default value for this flag; this value is used when no provider can obtain the
    /// value you are requesting. Consider it as a fallback.
    public var defaultValue: Value
    
    /// The value associated with flag; if specified it will be get by reading the value of the provider, otherwise
    /// the `defaultValue` is used instead.
    public var wrappedValue: Value {
        flagValue()
    }
    
    /// A reference to the `Flag` itself is available as a projected value
    /// so you can access to all associated informations.
    public var projectedValue: Flag<Value> {
        self
    }
    
    /// This is the full keypath which will be send to the associated providers to get the value
    /// of the feature flag. It's composed according to the `FlagLoader`'s configuration.
    /// If you need to override the behaviour by setting your own key pass `key` to init function.
    public var keyPath: FlagKeyPath {
        loader.keyPathForProperty(withFixedKey: fixedKey)
    }
    
    /// Metadata information associated with the flag.
    /// Typically is a way to associated a context to the flag in order to be fully documented.
    public var metadata: FlagMetadata
    
    /// You can limit the fetch of the loader to only certain list of provider types
    /// (for example a particular property should be fetched only from UserDefaults and not from Firebase).
    /// If you need of this feature you should set their types here; if `nil` it will use the order specified
    /// by the `FlagsLoader` instance which create the instance.
    public var allowedProviders: [FlagProvider.Type]?
    
    // MARK: - Private Properties
    
    /// The loader used to retrive the fetched value for property flags.
    /// This value is assigned when the instance of the Flag is created and it set automatically
    /// by the `configureWithLoader()` function.
    private var loader = LoaderBox()
    
    /// You can force a fixed key for a property instead of using auto-evaluation.
    private var fixedKey: String?
        
    // MARK: - Initialization
    
    /// Initialize a new feature flag property.
    ///
    /// - Parameters:
    ///   - name: name of the property. It's used only for debug/ui purpose but you can omit it.
    ///   - key: if specified this is the key used to fetch the property from providers list. If not specified the value is generated
    ///          by reading the property's name itself in format specified by the parent `FlagLoader`'s `keysConfiguration` property.
    ///   - default: the default value is used when key cannot be found in `FlagLoader`'s providers.
    ///   - allowedProviders: you can limit the providers where to get the value; if you specify a non `nil` array of types only instances
    ///                       of these types are queried to get value.
    ///   - description: description of the proprerty; you are encouraged to provide a short description of the feature flag.
    public init(name: String? = nil, key: String? = nil,
                default defaultValue: Value,
                allowedProviders: [FlagProvider.Type]? = nil,
                description: FlagMetadata) {
        
        self.defaultValue = defaultValue
        self.allowedProviders = allowedProviders
        self.fixedKey = key
        
        var info = description
        info.name = name
        self.metadata = info
    }
    
    public var debugDescription: String {
        "\(keyPath.fullPath)=\(wrappedValue)"
    }
        
    /// Return the value of the property by asking to the list of providers set.
    ///
    /// - Returns: `Value?`
    public func flagValue() -> Value {
        guard let loader = loader.instance else {
            return defaultValue // no loader has been set, we want to get the fallback result.
        }
        
        let keyPath = self.keyPath
        for provider in loader.providers ?? [] where isProviderAllowed(provider) {
            if let value: Value = provider.valueForFlag(key: keyPath) {
                // first valid result for provider is taken and returned
                return value
            }
        }
        
        // no value are found iterating loader's providers so we'll return the fallback value.
        return defaultValue
    }
    
    // MARK: - Internal Functions

    /// Return `true` if a provider is in the list of allowed providers specified in `limitProviders`.
    ///
    /// - Parameter provider: provider to check.
    /// - Returns: `true` if it's allowed, `false` otherwise.
    private func isProviderAllowed(_ provider: FlagProvider) -> Bool {
        guard let allowedProviders = self.allowedProviders else { return true }
        
        return allowedProviders.first { allowedType in
            allowedType == type(of: provider)
        } != nil
    }
    
    /// Configure the property with the given loader which created it.
    ///
    /// - Parameters:
    ///   - loader: loader.
    ///   - keyPath: path.
    public func configureWithLoader(_ loader: FlagsLoaderProtocol, propertyName: String, keyPath: [String]) {
        self.loader.instance = loader
        self.loader.propertyName = propertyName
        self.loader.propertyPath = keyPath
    }
    
}

// MARK: - Flag (Equatable)

extension Flag: Equatable where Value: Equatable {
    
    public static func ==(lhs: Flag, rhs: Flag) -> Bool {
        return lhs.keyPath == rhs.keyPath && lhs.wrappedValue == rhs.wrappedValue
    }
    
}

// MARK: - Flag (Hashable)

extension Flag: Hashable where Value: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(keyPath)
        hasher.combine(wrappedValue)
    }
    
}

// MARK: - LoaderBox

/// This class is used only to avoid modifying the property wrapper itself which is immutable.
/// It just hold a weak reference to the loaded holder.
internal class LoaderBox {
    
    /// Identify the instance of the loader.
    weak var instance: FlagsLoaderProtocol?
    
    /// Used to store the name of the property when you have not set a fixed key in property.
    var propertyName: String?
    
    /// Path to the property.
    var propertyPath: [String] = []
    
    func keyPathForProperty(withFixedKey fixedKey: String?) -> FlagKeyPath {
        let keyTransform = instance?.keyConfiguration.keyTransform ?? .none
        let pathSeparator = instance?.keyConfiguration.pathSeparator ?? "/"

        let propertyKey = (fixedKey ?? propertyName) ?? ""
        var components = propertyPath.map( { $0.transform(keyTransform) }) + [propertyKey.transform(keyTransform)]
        if let prefix = instance?.keyConfiguration.globalPrefix {
            components.insert(prefix.transform(keyTransform), at: 0)
        }
        
        return FlagKeyPath(components: components, separator: pathSeparator)
    }
    
    init() {}
}
