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
import FirebaseRemoteConfig

public protocol FirebaseRemoteConfigProviderDelegate: AnyObject {
    
    /// Called when initialization did ends.
    ///
    /// - Parameters:
    ///   - remote: remote configuration provider.
    ///   - didFetchData: status.
    ///   - error: error description if any.
    func firebaseProvider(_ remote: FirebaseRemoteProvider,
                          didFetchData: RemoteConfigFetchAndActivateStatus,
                          error: Error?)
    
}
