## IndomioFlags

IndomioFlags makes it easy to configure feature flags in your codebase. It's designed for Swift and  provides a simple and elegant abstraction layer over multiple providers which you can query with your own priority.

Main Features:
- **Simple & Elegant**: Effectively describe and organize your own flags (we support Property Wrapper and Dynamic Member Lookup!)
- **Transparent**: Abstract over many service implementations
- **Customizable Providers**: Use one of the built-in providers (LocalProvider, UserDefaults) or write your own easily. We support FirebaseRemoteConfig too!
- **Easy to use**: a simple UI you can integrate in your developer's mode allows you to customize and read flags at glance!
- **Fast**: Enable, disable and customize features at runtime
- **Reactive**: We support Combine extensions (only on Apple platforms)


It's compatible with iOS, macOS, watchOS and virtually any platform supported by Swift (including Linux servers and Windows).