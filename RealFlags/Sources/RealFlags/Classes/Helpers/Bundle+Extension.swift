//
//  RealFlags
//  Easily manage Feature Flags in Swift
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Immobiliare.it SpA. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

extension Bundle {
    
    private static let internalBundle = Bundle(for: FlagsBrowserController.self)
    
    internal static var libraryBundle: Bundle {
        #if SWIFT_PACKAGE
        Bundle.module
        #else
        [
            Bundle(url: internalBundle.bundleURL.appendingPathComponent("RealFlags.bundle")),
            internalBundle
        ].lazy.compactMap({ $0 }).first ?? Bundle.main
        #endif
    }
    
}

