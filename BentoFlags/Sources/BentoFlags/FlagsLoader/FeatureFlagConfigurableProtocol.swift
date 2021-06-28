//
//  File.swift
//  
//
//  Created by Daniele on 28/06/21.
//

import Foundation

public protocol FeatureFlagConfigurableProtocol {
    
    func configureWithLoader(_ loader: FlagsLoaderProtocol, propertyName: String, keyPath: [String])
    
}
