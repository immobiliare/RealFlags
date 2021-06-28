//
//  File.swift
//  
//
//  Created by Daniele on 28/06/21.
//

import Foundation

public protocol AnyFlag {
    
}

extension Flag: AnyFlag {
    
}

public protocol AnyFlagCollection {
    
    func flags() -> [AnyFlag]
    
}

extension FlagCollection: AnyFlagCollection {

    public func flags() -> [AnyFlag] {
        let properties = Mirror(reflecting: self.wrappedValue).children.lazy.map { $0.value }
        return []
    }

}
