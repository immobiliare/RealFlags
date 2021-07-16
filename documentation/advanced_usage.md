[↑ Index](./../README.md)
[← Organize Feature Flags](./../organize_feature_flags.md)

# 3. Advanced Usage

## 3.1 Using `FlagsManager`

As you see above you need to allocate a `FlagsLoader` to read values for a feature flag collection. You also need to keep this flags loader instances around; `FlagsManager` allows you to collect, keep alive and manage feature flags collection easily.

While you don't need to use it we suggests it as entry point to query your data.

`FlagsManager` is pretty easy to use; consider you want to load structure for several feature flags collection.  
Create a single instance of a `FlagsLoader` and use the `addCollection()` function; this is a silly example in `AppDelegate` but you can do better for sure:

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Main manager
    public lazy var flagsManager: FlagsManager = {
        // Create data providers
        let localProvider = LocalProvider()
        let firebaseProvider = FirebaseRemoteProvider()

        // Create the configuration to manage automatic ff key evaluation
        let config = KeyConfiguration(prefix: "myapp_", pathSeparator: "/", keyTransform: .snakeCase)

        // Instantiate our manager
        let manager = FlagsManager(
            providers: [localProvider, firebaseProvider], 
            keyConfiguration: config
        )

        // Load some structures
        manager.addCollection(removeCollection.self) // main collection
        manager.addCollection(ExperimentalFlags.self) // other collection

        return manager
    }()

    // Shortcut
    public var appFlags: FlagsLoader<AppFeatureFlags> {
        manager.addCollection(AppFeatureFlags.self)
    }
}
```

Now you can forget to keep your collection alive or load them anytime you need of them. Just ask for `appFlags`:

```swift
let cRatingMode = (UIApplication.shared as? AppDelegate)?.appFlags.ratingMode
```

You can also remove collection from `FlagsManager` using the `removeCollection()` function.

> NOTE: As you may have noticed only a single collection type can be loaded by a `FlagsManager`: you can't have multiple instances of the same collection type.

