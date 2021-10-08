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

public struct FlagKeyPath: Equatable, Hashable {
    
    public static let DefaultPathSeparator = "/"
    
    // MARK: - Public Properties
    
    /// Components of the key to retrive.
    public var pathComponents: [String]
    
    /// Separator set.
    public let pathSeparator: String
    
    public var fullPath: String {
        pathComponents.joined(separator: pathSeparator)
    }
    
    var key: String {
        pathComponents.last ?? ""
    }
    
    public var count: Int {
        pathComponents.count
    }
    
    public var first: String? {
        pathComponents.first
    }
    
    public var last: String? {
        pathComponents.last
    }
    
    public subscript(_ index: Int) -> String? {
        guard index >= 0, index < pathComponents.count else {
            return nil
        }
        
        return pathComponents[index]
    }
    
    @discardableResult
    public func dropFirst() -> FlagKeyPath {
        return FlagKeyPath(components: Array(pathComponents.dropFirst()), separator: pathSeparator)
    }
    
    public var isEmpty: Bool {
        pathComponents.isEmpty
    }
    
    // MARK: - Initialization
    
    internal init(components: [String], separator: String) {
        self.pathComponents = components
        self.pathSeparator = separator
    }

}
