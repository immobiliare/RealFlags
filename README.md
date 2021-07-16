# IndomioFlags
IndomioFlags makes it easy to configure feature flags in your codebase. It's designed for Swift and  provides a simple and elegant abstraction layer over multiple providers you can query with your own priority.

## Features

- **Simple & Elegant**: Effectively describe and organize your own flags with a type-safe structure.
- **Compact**: Thanks to Swift's Property Wrapper you will consistently reduce the amount of code to manage your feature flags.
- **Extensible**: Feature Flags supports all primitive datatypes: `Int` (and any numeric variant), `String`, `Bool`, `Data`, `Date`, `URL`, `Dictionary`, `Array` (values must conform to `FlagProtocol`), Optional Values and virtually any object conforms to `Codable` protocol!
- **Transparent**: IndomioFlags abracts over many service implementations with ease.
- **Extensible**: You can use one of the default data providers or create your own. We support Firebase Remote and Local configurations too.
- **Configurable**: a simple UI you can integrate in your developer's mode allows you to customize and read flags at glance, even for PMs.
- **Fast**: Enable, disable and customize features at runtime
- **Reactive**: We support Combine extensions (only on Apple platforms)

## What you get

Our goal making IndomioFlags is to provide a type-safe abstract way to describe and query for feature flags.

First and foremost you must describe your collection of flags.

```swift
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
let local = LocalProvider(localURL: fileURL)
let fb = FirebaseRemoteProvider()

let userFlagsLoader = FlagsLoader(UserFlags.self, providers: [fb, local])
```

Now you can query values from `userFlagsLoader` by using the `UserFlags` structure (it suppports autocomplete and type-safe value thanks to `@dynamicMemberLookup`!).  
Let me show it:

```swift
if userFlagsLoader.showSocialLogin {
    // do some stuff
}
```

Values are obtained respecting the order you have specified, in this case from Firebase Remote Config service then, when no value is found, into the local repository.  
If no values are available the default value specified in `@Flags` annotation is returned.

This is just an overview of the library; if you want to know more follow the documentation below.

## Documentation

The following documentation describe detailed usage of the library.

- 1. [Introduction](./documentation/introduction.md)
    - 1.1. `@Flag` Annotation
    - 1.2. `@Flag` Supported Data Types
    - 1.3. Load a Feature Flag Collection in a `FlagLoader`
    - 1.4. Configure Key Evaluation for `FlagsLoader`'s `@Flag`
    - 1.5. Query a specific data provider
- 2. [Organize Feature Flags](./documentation/organize_feature_flags.md)
    - 2.1 The `@FlagCollection` annotation
    - 2.2 Nested Structures
- 3. [Advanced Usage](./documentation/advanced_usage.md)
    3.1. Using `FlagsManager` singleton
    3.2. 
