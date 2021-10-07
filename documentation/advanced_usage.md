[↑ DOCUMENTATION INDEX](./../README.md#documentation)

# 3. Advanced Usage

- 3.1 - [Using FlagsManager](#31-using-flagsmanager)
- 3.2 - [Use and Creation of Data Providers](#32---use-and-creation-of-data-providers)
- 3.3 - [Firebase Remote Config with FirebaseRemoteProvider](#33-firebase-remote-config-with-firebaseremoteprovider)
- 3.4 - [Modify a feature flag at runtime](#34-modify-a-feature-flag-at-runtime)
- 3.5 - [Flags Browser & Editor](#35-flags-browser--editor)

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

[↑ INDEX](#3-advanced-usage)

## 3.2 - Use and Creation of Data Providers

RealFlags create an abstract layer of the vertical feature flags implementations. You can use or create a new data provider which uses your service without altering the structure of your feature flags.

Each data provider must be conform to the `FlagsProvider` protocol which defines two important methods:

```swift
// get value
func valueForFlag<Value>(key: FlagKeyPath) -> Value? where Value: FlagProtocol

// set value
func setValue<Value>(_ value: Value?, forFlag key: FlagKeyPath) throws -> Bool where Value: FlagProtocol
```

One for getting value and another for set.  
If your data provider does not provide writable support you must set the `isWritable = false` to inhibit the operation.

RealFlags supports the following built-in providers:
- `LocalProvider` is a local XML based provider which support read&write and storage of any property type including all objects conform to `Codable` protocol. You can instantiate an ephimeral data provider (in-memory) or a file-backed provider to persists data between app restarts.
- any `UserDefaults` instance is conform to `FlagsProvider` so you can use it as a data provider. It supports read&write with also `Codable` objects supports too.
- `DelegateProvider` is just a forwarder object you can use to attach your own implementation without creating a `FlagsProvider` conform object.

Then the following remote providers (you can fetch from a separate package):
- `FirebaseRemoteProvider` supports Firebase Remote Config feature flag service. It supports only read and only for primitive types (no JSON is supported but you can use your own Strings).

[↑ INDEX](#3-advanced-usage)

## 3.3 Firebase Remote Config with `FirebaseRemoteProvider`

`FirebaseRemoteProvider` is the data provider for [Firebase Remote Config](https://firebase.google.com/docs/remote-config) service.  
You can use it by fetching the additional `RealFlagsFirebase` from SwiftPM or CocoaPods (it will dependeds by [Firebase iOS SDK](https://github.com/firebase/firebase-ios-sdk.git)).

Once fetched remember to configure your Firebase SDK before load the provider.  
This is just an example:

```swift
import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Firebase app
        FirebaseApp.configure()

        // Now you can use 
        let firebaseProvider = FirebaseRemoteProvider()
        firebaseProvider.delegate = self
        let manager = FlagsManager(providers: [firebaseProvider])
        
        return true
    }

}
```

You can also use the `delegate` to receive important events from SDK:

```swift
extension AppDelegate: FirebaseRemoteConfigProviderDelegate {

    func firebaseProvider(_ remote: FirebaseRemoteProvider,
                          didFetchData: RemoteConfigFetchAndActivateStatus,
                          error: Error?)
        // Data is fetched from SDK
    }

}
```

[↑ INDEX](#3-advanced-usage)

## 3.4 Modify a feature flag at runtime 

While generally you don't need to modify at runtime the value of a feature flag, sometimes you may need of this feature. 

Each `@Flag` annotated property supports the `setValue()` function to alter its value; this is allowed by accessing to the projected value:

```swift
appFlags.$ratingMode.setValue("altered value",
                              providers: [LocalProvider.self])
```

In addition to the new value it also takes the list of data providers to afftect.  
Obivously not all data provider supports writing new values; for example you can't send values to the Firebase Remote Config via `FirebaseRemoteProvider`. 
However you can store a new value in a `LocalProvider` instance.

The method return a boolean indicating the result of the operation.

In this example we're assign a new JSON value to a property:

```swift
// JSON type is represented via JSONData object which encapsulate a dictionary.
let json = JSONData(["column": 5, "showDesc": true, "title": true])
appFlags.ui.$layoutAttributes.setValue(json, providers: [LocalProvider.self])
```

[↑ INDEX](#3-advanced-usage)

## 3.5 Flags Browser & Editor

Flags Browser is a small UI tool for displaying and manipulating feature flags.  
It's part of the library and you can include it in your product like inside the developer's mode or similar.

![](./assets/flags_browser_video.mp4)

It's really easy to use, just allocate and push our built-in view controller by passing a list of `FlagsLoader` or a `FlagsManager`; RealFlags takes care to read all values and show them in a confortable user interface.

If you are using `FlagsManager` to keep organized your flags just pass it to the init:

```swift
var flagsManager = FlagsManager(providers: [...])

func showFlagsBrowser() {
    flagsBrowser = FlagsBrowserController.create(manager: flagsManager)
    present(flagsBrowser, animated: true, completion: nil)
}
```

Otherwise you can pass one or more `FlagsLoader` you wanna show:

```swift
var userFlags: FlagsLoader<UserFlagsCollection> = ...
var expFlags: FlagsLoader<ExperimentalFlagsCollection> = ...

func showFlagsBrowser() {
    flagsBrowser = FlagsBrowserController.create(loaders: [userFlags, expFlags])
    present(flagsBrowser, animated: true, completion: nil)
}
```

And you're done! You will get a cool UI with detailed description of each flags along its types and values for each data provider which allows developers and product owners to check and alter the state of the app!

The following properties of `@Flag` properties are used by the Flags Browser to render the UI:

- `name`: provide the readable name of the property. If not specified the signature of the property is used automatically.
- `description`: provide a short description of the property which is useful both for devs and product owners.
- `keyPath`: provide the full keypath of the property which is queried to any set data providers. If not specified it will be evaluated automatically ([see here](./documentation/introduction.md#1.1)).
- `isUILocked`: set to `true` in order to prevent altering the property from the Flags Browser. By default is `false`.
- `defaultValue`: show the value of fallback when no value can be obtained to any data provider.
- `metadata`: contains useful settings for flag (see below)

A `Flag` instance also include a `FlagMetadata` object (via `.metadata`) which exposes several additional properties:

- `uiIcon`: an optional icon to show in Flags Browser. By default you can keep it `nil` and the default datatype icon is used (default is `nil`).
- `isLocked`: when `true` you cannot change the value of the flag via Flags Browser (default is `false`).
- `isInternal`: when `true` value is not visible in Flags Browser (default is `false`)

[↑ INDEX](#3-advanced-usage)