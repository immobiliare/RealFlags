<p align="center">
<img src="./documentation/assets/indomioflags_logo.png" alt="Indomio" width="550"/>
</p>

<p align="center">
<a href="https://developer.apple.com/swift"><img alt="Swift5" src="https://img.shields.io/badge/language-Swift5-orange.svg"/></a>
<!---<a href="https://github.com/malcommac/IndomioFlags/releases/latest"><img alt="Release" src="https://img.shields.io/github/release/malcommac/IndomioFlags.svg"/></a> -->
<!--- <a href="https://cocoapods.org/pods/IndomioFlags"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/IndomioFlags.svg"/></a> -->
<a href="https://swift.org/package-manager"><img alt="Swift Package Manager" src="https://img.shields.io/badge/SwiftPM-compatible-yellowgreen.svg"/></a>
</br>
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-green.svg"/></a>
<a href="https://github.com/malcommac/IndomioFlags/blob/master/LICENSE"><img alt="Lincense" src="http://img.shields.io/badge/License-Apache%202.0-black.svg"/></a>
</p>

IndomioFlags makes it **easy to configure feature flags** in your codebase.  
It's designed for Swift and **provides a simple and elegant abstraction layer** over multiple providers you can query with your own priority.  
It also comes with an **handy UI tool to browse and alter values directly at runtime!**

<br/>
<p align="center">
<b><a href="#features">Features</a></b>
|
<b><a href="#whatyouget">What You Get</a></b>
|
<b><a href="#flagsbrowser">Flags Browser & Editor</a></b>
|
<b><a href="#tests">Tests</a></b>
|
<b><a href="#documentation">Documentation</a></b>
|
<b><a href="#requirements">Requirements</a></b>
|
<b><a href="#installation">Installation</a></b>
|
<b><a href="#powered">Powered Apps</a></b>
|
<b><a href="#support">Support & Contribute</a></b>
|
<b><a href="#license">License</a></b>
</p>
<br/>

<a name="#features"/>

## Features Highlights

- 💡 **Simple & Elegant**: Effectively describe and organize your own flags with a type-safe structure. It will abstract your implementation and consistently reduce the amount of code to manage your feature flags
- 💡 **Extensible**: You can use one of the default data providers or create your own. We support Firebase Remote and Local configurations too
- 💡 **Complete**: Feature Flags supports all primitive datatypes and complex objects: `Int` (and any numeric variant), `String`, `Bool`, `Data`, `Date`, `URL`, `Dictionary`, `Array` (values must conform to `FlagProtocol`), Optional Values and virtually any object conforms to `Codable` protocol!
- 💡 **Configurable**: Enable, disable and customize features at runtime
- 💡 **Integrated UI Tool**: the handy UI Tool allows you to customize and read flags at glance

<a name="#whatyouget"/>

## What You Get

Our goal making IndomioFlags is to provide a type-safe abstract way to describe and query for feature flags.

The first step is to  describe your collection of flags:

```swift
// Define the structure of your feature flags with type-safe properties!
struct UserFlags: FlagCollectionProtocol {
    @Flag(default: true, description: "Show social login options along native login form")
    var showSocialLogin: Bool
    
    @Flag(default: 0, description: "Maximum login attempts before blocking account")
    var maxLoginAttempts: Int
    
    @Flag(key: "rating_mode", default: "at_launch", description: "The behaviour to show the rating popup")
    var appReviewRating: String
}
```

This represent a type-safe description of some flags grouped in a collection. 
Each feature flags property is identified by the `@Flag` annotation. 
It's time load values for this collection; using a new `FlagsLoader` you will be able to load and query collection's values from one or more data provider:

```swift
// Allocate your own data providers
let localProvider = LocalProvider(localURL: fileURL)
let fbProvider = FirebaseRemoteProvider()

// Loader is the point for query values
let userFlagsLoader = FlagsLoader(UserFlags.self, // load flags definition
                                  providers: [fbProvider, localProvider]) // set providers
```

Now you can query values from `userFlagsLoader` by using the `UserFlags` structure (it suppports autocomplete and type-safe value thanks to `@dynamicMemberLookup`!).  
Let me show it:

```swift
if userFlagsLoader.showSocialLogin { // query properties as type-safe with autocomplete!
    // do some stuff
}
```

Values are obtained respecting the order you have specified, in this case from Firebase Remote Config service then, when no value is found, into the local repository.  
If no values are available the default value specified in `@Flags` annotation is returned.

This is just an overview of the library; if you want to know more follow the [documentation below](#documentation).

<a name="#flagsbrowser"/>

## Flags Browser & Editor

IndomioFlags also comes with an handy tool you can use to browse and edit feature flags values directly in your client! It can be useful for testing purpose or allow product owners to enable/disable and verify features of the app.

[Checkout the doc for more infos!](./documentation/advanced_usage.md#3.5)

![](./documentation/assets/flags_browser_intro.gif)

<a name="#tests"/>

## Tests

IndomioFlags includes an extensive collection of unit tests: you can found it into the `Tests` directory.

<a name="#documentation"/>

## Documentation

The following documentation describe detailed usage of the library.

- [1 - Introduction](./documentation/introduction.md)  
    - [1.1 - `@Flag` Annotation](./documentation/introduction.md#1.1)   
    - [1.2 - `@Flag` Supported Data Types](./documentation/introduction.md#1.2)   
    - [1.3 - Load a Feature Flag Collection in a `FlagLoader`](./documentation/introduction.md#1.3)   
    - [1.4 - Configure Key Evaluation for `FlagsLoader`'s `@Flag`](./documentation/introduction.md#1.4)   
    - [1.5 - Query a specific data provider](./documentation/introduction.md#1.5)   
- [2 - Organize Feature Flags](./documentation/organize_feature_flags.md)  
    - [2.1 - The `@FlagCollection` annotation](./documentation/organize_feature_flags.md#2.1)  
    - [2.2 - Nested Structures](./documentation/organize_feature_flags.md#2.2)  
    - [2.3 - Configure `FlagCollection`'s contribution to properties keypath generation](./documentation/organize_feature_flags.md#2.3)  
- [3 - Advanced Usage](./documentation/advanced_usage.md)  
    - [3.1 - Using `FlagsManager`](./documentation/advanced_usage.md#3.1)  
    - [3.2 - Use and Creation of Data Providers](./documentation/advanced_usage.md#3.2)  
    - [3.3 - Firebase Remote Config with `FirebaseRemoteProvider`](./documentation/advanced_usage.md#3.3)  
    - [3.4 - Modify a feature flag at runtime](./documentation/advanced_usage.md#3.4)  
    - [3.5 - Flags Browser & Editor](./documentation/advanced_usage.md#3.5)
    
<a name="#requirements"/>

## Requirements

IndomioFlags can be installed in any platform which supports Swift 5.4+ including Windows and Linux. On Apple platform the following configuration is required:

- iOS 12+, watchOS 7+, tvOS 9+
- Xcode 12.5+
- Swift 5.4+

<a name="#installation"/>

## Installation

To use IndomioFlags in your project you can use Swift Package Manager (our primary choice) or CocoaPods.

### Swift Package Manager

Aadd it as a dependency in a Swift Package, add it to your Package.swift:

```swift
dependencies: [
    .package(url: "", from: "1.0.0")
]
```

And add it as a dependency of your target:

```swift
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "", package: "")
    ])
]
```

In Xcode 11+ you can also navigate to the File menu and choose Swift Packages -> Add Package Dependency..., then enter the repository URL and version details.

### CocoaPods

IndomioFlags can be installed with CocoaPods by adding pod 'IndomioFlags' to your Podfile.

```ruby
pod 'IndomioFlags'
```
<a name="#powered"/>

## Powered Apps

IndomioFlags was created by the amazing mobile team at ImmobiliareLabs, the Tech dept at Immobiliare.it, the first real estate site in Italy.  
We are currently using IndomioFlags in all of our products.

**If you are using IndomioFlags in your app [drop us a message](mailto://mobile@immobiliare.it), we'll add below**.

<a href="https://apps.apple.com/us/app/immobiiiare-it-indomio/id335948517"><img src="./documentation/assets/powered_by_indomioflags_apps.png" alt="Indomio" width="270"/></a>

<a name="#support"/>

## Support & Contribute

<p align="center">
Made with ❤️ by <a href="https://github.com/orgs/immobiliare">ImmobiliareLabs</a> and <a href="https://github.com/.../graphs/contributors">Contributors</a>
<br clear="all">
</p>

We'd love for you to contribute to IndomioFlags!  
If you have any questions on how to use IndomioFlags, bugs and enhancement please feel free to reach out by opening a [GitHub Issue](https://github.com/.../issues).

<a name="#license"/>

## License

IndomioFlags is licensed under the Apache 2.0 license.  
See the [LICENSE](./LICENSE) file for more information.
