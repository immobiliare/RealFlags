[↑ Index](./../README.md)
[← Introduction](./../introduction.md)

# 2. Organize Feature Flags

## 2.1. The `@FlagCollection` annotation

IndomioFlags allows you to describe complex nested structure for flags. You can, for example, create a collection inside another collection and create a data tree for feature flags which better describe your application's requirements.

In order to define a sub-collection inside a root structure (a `FlagCollectionProtocol` conform object) you must use the `@FlagProtocol`: it allows you to identify another `FlagCollectionProtocol` collection.

Consider the following example:

```swift
struct AppFeatureFlags: FlagCollectionProtocol {
    // ...
    @FlagCollection(description: "Checkout Flags")
    var checkout: CheckoutFlags
    // ...
}
```

The `checkout` variable referes to another sub collection named `CheckoutFlags`:

```swift
struct CheckoutFlags: FlagCollectionProtocol {
    // ...
}
```

Once loaded you can use the dot notation to explore data in type-safe manner:

```swift
if appFlags.checkout.someProperty == "..." { ... }
```

A structure may contains subcollections and properties as you wish.

## 2.2. Nested Structures

While IndomioFlags leave you free to organize your feature flags the library's architecture itself encourage you to classify feature flags and group them according to your criteria.  
You can stay flat or you can create nested categories. 

A single struct conforms to `FlagCollectionProtocol` may contains both properties and other collections.

Consider the following example:

![](./assets/example_structure.png)

We have created a nested structure where the root is `AppFeatureFlags`.  
We can translate the following tree in IndomioFlags as follow *(not all properties are exposed for brevity)*:

```swift

struct AppFeatureFlags: FlagCollectionProtocol {
    @FlagCollection(description: "User's Related Flags")
    var user: UserFlags
    
    @FlagCollection(description: "Experimental Flags")
    var experimental: ExperimentalFlags

    @FlagCollection(description: "Checkout Flags")
    var checkout: CheckoutFlags

    @FlagCollection(description: "Color Themen")
    var colorTheme: JSONData?
}

struct UserFlags: FlagCollectionProtocol {
    @Flag(default: false, description: "Show Social Login Button")
    var showSocialLogin: Bool
    // ...
}

struct ExperimentalFlags: FlagCollectionProtocol {
    @Flag(default: false, description: "New cool cache algorithm")
    var enableFastPrecache: Bool
    
    @Flag(key: "list_layout", default: nil, description: "Layout settings (JSON)")
    var listLayoutSettings: JSONData?
}

struct CheckoutFlags: FlagCollectionProtocol {
    // ...
}
```

Now you have created the structure you can easily load the structure in a `FlagsLoader` instance and query their values with typesafe:

```swift
let appFlags = FlagsLoader(AppFeatureFlags.self, providers: [localProvider])

/// Somewhere in your code you can query a nested value
if appFlags.userFlags.showSocialLogin {
    // ...
}
```