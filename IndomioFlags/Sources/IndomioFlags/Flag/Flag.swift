//
//  IndomioFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import UIKit

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
        flagValue().value ?? defaultValue
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
    
    /// You can exclude from the fetch of the loader a certain list of provider types
    /// (for example a particular property should be fetched only from UserDefaults and not from Firebase).
    /// If you need of this feature you should set their types here; if `nil` it will use the order specified
    /// by the `FlagsLoader` instance which create the instance.
    public var excludedProviders: [FlagsProvider.Type]?
    
    // MARK: - Private Properties
    
    /// The loader used to retrive the fetched value for property flags.
    /// This value is assigned when the instance of the Flag is created and it set automatically
    /// by the `configureWithLoader()` function.
    internal private(set) var loader = LoaderBox()
    
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
                excludedProviders: [FlagsProvider.Type]? = nil,
                description: FlagMetadata) {
        
        self.defaultValue = defaultValue
        self.excludedProviders = excludedProviders
        self.fixedKey = key
        
        var info = description
        info.name = name
        self.metadata = info
    }
    
    public var debugDescription: String {
        "\(keyPath.fullPath)=\(wrappedValue)"
    }
    
    /// Return the value of the property by asking to the list of providers set.
    /// If a `providerType` is passed only that type is read.
    ///
    /// - Parameter providerType: provider type, if `nil` the providers list with `allowedProviders` is read.
    /// - Returns: Value
    public func flagValue(from providerType: FlagsProvider.Type? = nil, fallback: Bool = true) -> (value: Value?, source: FlagsProvider?) {
        guard loader.instance != nil else {
            return (defaultValue, nil) // no loader has been set, we want to get the fallback result.
        }
        
        let providersToQuery = providersWithTypes([providerType].compactMap({ $0}))
        let keyPath = self.keyPath
        for provider in providersToQuery where isProviderAllowed(provider) {
            if let value: Value = provider.valueForFlag(key: keyPath) {
                // first valid result for provider is taken and returned
                return (value, provider)
            }
        }
        
        return (nil, nil)
    }
    
    /// Allows to change the value of feature flag by overwriting it to all or certain types
    /// of providers.
    ///
    /// - Parameters:
    ///   - value: new value to set.
    ///   - providers: providers where apply changes. Not all provider may support changing flags;
    ///                if you dont' specify a valid set of provider's type it will be applied to all
    ///                providers assigned to the parent's `FlagLoader`.
    /// - Returns: Return the list of provider which accepted the change.
    @discardableResult
    public func setValue(_ value: Value?, providers: [FlagsProvider.Type]?) -> [FlagsProvider] {
        var alteredProviders = [FlagsProvider]()
        for provider in providersWithTypes(providers) {
            do {
                if try provider.setValue(value, forFlag: keyPath) {
                    alteredProviders.append(provider)
                }
            } catch { }
        }
        
        return alteredProviders
    }
    
    // MARK: - Internal Functions
    
    /// Return a filtered list of associated providers based on `types` received; if no values
    /// are specified no filter is applied and the list is complete.
    ///
    /// - Parameter types: types to filter.
    /// - Returns: [FlagsProvider]
    private func providersWithTypes(_ types: [FlagsProvider.Type]?) -> [FlagsProvider] {
        guard let filteredByTypes = types, filteredByTypes.isEmpty == false else {
            return allowedProviders() // no filter applied, return allowed providers.
        }
        
        // filter applied, return only providers which meet passed types ignoring allowed providers
        return loader.instance?.providers?.filter({ providerInstance in
            filteredByTypes.contains(where: { $0 == type(of: providerInstance) })
        }) ?? []
    }
    
    /// Allowed providers from the list of all providers of the parent `FlagsLoader`.
    ///
    /// - Returns: [FlagsProvider]
    private func allowedProviders() -> [FlagsProvider] {
        loader.instance?.providers?.filter({
            isProviderAllowed($0)
        }) ?? []
    }

    /// Return `true` if a provider is in the list of allowed providers specified in `limitProviders`.
    ///
    /// - Parameter provider: provider to check.
    /// - Returns: `true` if it's allowed, `false` otherwise.
    private func isProviderAllowed(_ provider: FlagsProvider) -> Bool {
        guard let excludedProviders = self.excludedProviders else { return true }
        
        return excludedProviders.first { allowedType in
            allowedType == type(of: provider)
        } == nil
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
        if let fixedKey = fixedKey {
            return FlagKeyPath(components: [fixedKey], separator: "/")
        }
        
        let keyTransform = instance?.keyConfiguration.keyTransform ?? .none
        let pathSeparator = instance?.keyConfiguration.pathSeparator ?? "/"

        let propertyKey = propertyName ?? ""
        var components = propertyPath.map( { $0.transform(keyTransform) }) + [propertyKey.transform(keyTransform)]
        if let prefix = instance?.keyConfiguration.globalPrefix {
            components.insert(prefix.transform(keyTransform), at: 0)
        }
        
        return FlagKeyPath(components: components, separator: pathSeparator)
    }
    
    init() {}
}
